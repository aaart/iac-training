variable "aks_rg" {
  type        = string
  description = "Resource group of the ACR."
}

variable "aks_tenant_id" {
  type        = string
  description = "Tenant ID of the ACR."
  
}

variable "aks_kv_id" {
    type        = string
    description = "ID of the Key Vault to store ACR credentials."
}

variable "aks_acr_name" {
  type        = string
  description = "Name of the ACR."
}

variable "aks_acr_password" {
  type        = string
  description = "Password of the ACR."
}

variable "aks_cluster_name" {
  type        = string
  description = "Name of the AKS cluster."
}

variable "aks_vnet_name" {
  type        = string
  description = "Name of the VNET."
}

variable "aks_subnet_name" {
  type        = string
  description = "Name of the VNET."
}

variable "aks_dns_prefix" {
  type        = string
  description = "DNS prefix of the AKS cluster."
}

variable "aks_vnet_address_space" {
  type        = list(string)
  description = "Address space of the VNET."
}

variable "aks_subnet_address_prefixes" {
  type        = list(string)
  description = "Address space of the subnet."
}