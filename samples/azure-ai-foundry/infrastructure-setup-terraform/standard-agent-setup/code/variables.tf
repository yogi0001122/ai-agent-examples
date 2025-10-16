variable "location" {
  description = "Azure location for resources"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the resource group where AI Foundry will be created"
  type        = string
}

variable "projects" {
  description = "List of AI Foundry projects and associated services"
  type = map(object({
    name        = string
    description = string
    openai = optional(object({
      openai_account_name   = string
      openai_resource_group = string
    }))
    ai_search = optional(object({
      aisearch_account_name   = string
      aisearch_resource_group = string
    }))
  }))
}

variable "subscription_id_infra" {
  description = "Subscription ID where the resource group exists"
  type        = string
}

variable "subscription_id_workload" {
  description = "Subscription ID where the AI Foundry resource will be created"
  type        = string
}

variable "subscription_id_resources" {
  description = "Subscription ID where OpenAI and AI Search resources exist"
  type        = string
  
}