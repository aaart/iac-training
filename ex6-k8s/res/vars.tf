variable "target_environment" {
  type        = string
  description = "Defines target environment type."
}

variable "az_resource_group" {
  type        = string
  description = "Target resource group."
}

variable "tenant_id" {
  type        = string
  description = "Tenant Id to assign resources with."
}

variable "terraforming_identity" {
  type        = string
  description = "Identity to set up resources."
}