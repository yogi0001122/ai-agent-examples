# ---------------------------------------------------------
# Data Blocks for OpenAI and AI Search
# ---------------------------------------------------------
data "azurerm_cognitive_account" "openai" {
  for_each = local.openai_projects

  name                = each.value.openai.openai_account_name
  resource_group_name = each.value.openai.openai_resource_group
}

data "azurerm_search_service" "aisearch" {
  for_each = local.aisearch_projects

  name                = each.value.ai_search.aisearch_account_name
  resource_group_name = each.value.ai_search.aisearch_resource_group
}
