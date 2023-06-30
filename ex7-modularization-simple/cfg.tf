terraform {
  required_version = ">= 1.5.2"
  backend "azurerm" {
  }
}


# default provider
provider "azurerm" {
  client_id            = var.default_client_id
  tenant_id            = var.default_tenant_id
  client_secret        = var.default_client_secret
  subscription_id      = var.default_subscription_id
  features {}
}