variable "az_resource_group" {
  type        = string
  description = "Target resource group. Sgould be provided by command line arguments."
}

variable "tenant_id" {
  type        = string
  description = "Tenant Id used to assign resources with."
}

variable "terraforming_identity" {
  type        = string
  description = "Identity used to set up resources."
}