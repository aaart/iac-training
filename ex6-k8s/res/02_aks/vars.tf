variable "aks_rg" {
  type        = string
  description = "Resource group of the ACR."
}

variable "aks_vnet_name" {
  type        = string
  description = "Name of the VNET."
}

variable "aks_subnet_name" {
  type        = string
  description = "Name of the VNET."
}

variable "aks_vnet_address_space" {
  type        = list(string)
  description = "Address space of the VNET."
}

variable "aks_subnet_address_prefixes" {
  type        = list(string)
  description = "Address space of the subnet."
}