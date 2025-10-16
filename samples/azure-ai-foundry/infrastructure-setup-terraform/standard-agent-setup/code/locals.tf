locals {
  openai_projects = {
    for k, v in var.projects : k => v
    if try(v.openai != null, false)
  }

  aisearch_projects = {
    for k, v in var.projects : k => v
    if try(v.ai_search != null, false)
  }
}
