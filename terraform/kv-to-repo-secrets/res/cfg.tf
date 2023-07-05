terraform {
  required_version = ">= 1.5.2"
  backend "azurerm" {
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}


# default provider
provider "azurerm" {
  client_id            = var.azurerm_client_id
  tenant_id            = var.azurerm_tenant_id
  client_secret        = var.azurerm_client_secret
  subscription_id      = var.azurerm_subscription_id
  features {}
}

provider "github" {
  token = var.github_token
}