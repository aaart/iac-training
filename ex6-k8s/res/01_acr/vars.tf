variable "acr_name" {
  type        = string
  description = "Name of the ACR."
}

variable "acr_rg" {
  type        = string
  description = "Resource group of the ACR."
}

variable "kv_id" {
  type        = string
  description = "ID of the Key Vault to store ACR password."
}