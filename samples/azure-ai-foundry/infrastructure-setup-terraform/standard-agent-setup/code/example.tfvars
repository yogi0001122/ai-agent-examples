resource_group_name = "rg-ai-foundry-yogi0001122-3"
location            = "eastus"
subscription_id_resources = "subscription_id_workload"
subscription_id_infra     = "subscription_id_workload"
subscription_id_workload = "subscription_id_workload"


projects = {
  project1 = {
    name        = "ai-foundry-proj1"
    description = "AI Foundry project with OpenAI and Search"
    openai = {
      openai_account_name   = "openai-prod-eastus-yogi0001122"
      openai_resource_group = "rg-ai"
    }

  }

  project2 = {
    name        = "ai-foundry-proj2"
    description = "AI Foundry project with OpenAI only"
    ai_search = {
      aisearch_account_name   = "search-prod-eastus-yogi0001122"
      aisearch_resource_group = "rg-ai"
    }
  }
}
