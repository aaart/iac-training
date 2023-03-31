terraform {
  required_version = ">= 1.3.7"
  # backend "azurerm" {
  #   resource_group_name  = "#{ secrets.terraform_resource_group }#"
  #   storage_account_name = "#{ secrets.terraform_storage_account }#"
  #   container_name       = "#{ secrets.terraform_container }#"
  #   key                  = "#{ secrets.terraform_key }#"
  # }
  backend "local" {
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = module.aks.aks_host_url
  client_certificate     = base64decode(module.aks.aks_client_certificate)
  client_key             = base64decode(module.aks.aks_client_key)
  cluster_ca_certificate = base64decode(module.aks.aks_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = module.aks.aks_host_url
    client_certificate     = base64decode(module.aks.aks_client_certificate)
    client_key             = base64decode(module.aks.aks_client_key)
    cluster_ca_certificate = base64decode(module.aks.aks_ca_certificate)
  }
}