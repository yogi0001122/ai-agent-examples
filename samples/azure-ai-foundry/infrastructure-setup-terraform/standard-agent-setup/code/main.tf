# ---------------------------------------------------------
# Resource Group
# ---------------------------------------------------------
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}


## Create a random string
##
resource "random_string" "unique" {
  length      = 4
  min_numeric = 4
  numeric     = true
  special     = false
  lower       = true
  upper       = false
}
# ---------------------------------------------------------
# AI Foundry Workspace
# ---------------------------------------------------------
## Create the AI Foundry resource
##
resource "azapi_resource" "ai_foundry" {
  provider = azapi.workload_subscription

  type                      = "Microsoft.CognitiveServices/accounts@2025-06-01"
  name                      = "aifoundry${random_string.unique.result}"
  parent_id                 = "/subscriptions/${var.subscription_id_resources}/resourceGroups/${azurerm_resource_group.main.name}"
  location                  = var.location
  schema_validation_enabled = false

  body = {
    kind = "AIServices",
    sku = {
      name = "S0"
    }
    identity = {
      type = "SystemAssigned"
    }

    properties = {
      disableLocalAuth = false
      allowProjectManagement = true
      customSubDomainName = "aifoundry-yogi0001122-3-${random_string.unique.result}"
      publicNetworkAccess = "Disabled"
      networkAcls = {
        defaultAction = "Allow"
      }

    }
  }
}

resource "time_sleep" "wait_for_foundry" {
  depends_on = [azapi_resource.ai_foundry]
  create_duration = "30s"
}


# ---------------------------------------------------------
# AI Foundry Projects
# ---------------------------------------------------------
resource "azapi_resource" "ai_foundry_project" {
  for_each = var.projects

  type      = "Microsoft.CognitiveServices/accounts/projects@2025-06-01"
  name      = each.value.name
  parent_id = azapi_resource.ai_foundry.id
  location  = var.location
  schema_validation_enabled = false

  body = {
    properties = {
      description = each.value.description
    }
    identity = {
      type = "SystemAssigned"
    }
  }
  depends_on = [ time_sleep.wait_for_foundry]
}


# ---------------------------------------------------------
# OpenAI → Foundry Project Connections
# ---------------------------------------------------------
resource "azapi_resource" "conn_openai" {
  for_each = local.openai_projects

  type                      = "Microsoft.CognitiveServices/accounts/projects/connections@2025-06-01"
  name                      = data.azurerm_cognitive_account.openai[each.key].name
  parent_id                 = azapi_resource.ai_foundry_project[each.key].id
  schema_validation_enabled = false

  depends_on = [
    azapi_resource.ai_foundry
  ]

  body = {
    name = data.azurerm_cognitive_account.openai[each.key].name

    properties = {
      category = "AzureOpenAI"
      target   = trim(data.azurerm_cognitive_account.openai[each.key].endpoint, "/")
      authType = "AAD"

      metadata = {
        ApiType     = "Azure"
        ApiVersion  = "2025-05-01-preview"
        ResourceId  = data.azurerm_cognitive_account.openai[each.key].id
        location    = var.location
      }
    }
  }
}

# ---------------------------------------------------------
# AI Search → Foundry Project Connections
# ---------------------------------------------------------
resource "azapi_resource" "conn_aisearch" {
  for_each = local.aisearch_projects

  type                      = "Microsoft.CognitiveServices/accounts/projects/connections@2025-06-01"
  name                      = data.azurerm_search_service.aisearch[each.key].name
  parent_id                 = azapi_resource.ai_foundry_project[each.key].id
  schema_validation_enabled = false

  depends_on = [
    azapi_resource.ai_foundry
  ]

  body = {
    name = data.azurerm_search_service.aisearch[each.key].name

    properties = {
      category = "CognitiveSearch"
      target   = "https://${each.value.ai_search.aisearch_account_name}.search.windows.net"
      authType = "AAD"

      metadata = {
        ApiType     = "Azure"
        ApiVersion  = "2025-05-01-preview"
        ResourceId  = data.azurerm_search_service.aisearch[each.key].id
        location    = var.location
      }
    }
  }
}
