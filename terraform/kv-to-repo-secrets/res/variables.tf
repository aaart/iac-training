variable "azurerm_tenant_id" {
  type = string 
}

variable "azurerm_subscription_id" {
  type = string 
}

variable "azurerm_client_id" {
  type = string 
}

variable "azurerm_client_secret" {
  type = string 
}

variable "kv_name" {
  type = string 
}

variable "kv_resource_group_name" {
  type = string 
}

variable "kv_secrets" {
  type = string
  description = "space separated list of secret names to be retrieved from the key vault."
}

variable "github_token" {
  type = string
}

variable "github_owner" {
  type = string
}

variable "github_repository_name" {
  type = string
}

variable "github_repository_environment" {
  type = string
}
