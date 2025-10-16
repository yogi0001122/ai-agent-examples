output "ai_foundry_id" {
  description = "The ID of the AI Foundry workspace"
  value       = azapi_resource.ai_foundry.id
}

output "ai_foundry_projects" {
  description = "All created AI Foundry projects"
  value = {
    for k, v in azapi_resource.ai_foundry_project : k => v.id
  }
}

output "openai_connections" {
  description = "Connection IDs for OpenAI"
  value = {
    for k, v in azapi_resource.conn_openai : k => v.id
  }
}

output "aisearch_connections" {
  description = "Connection IDs for AI Search"
  value = {
    for k, v in azapi_resource.conn_aisearch : k => v.id
  }
}
