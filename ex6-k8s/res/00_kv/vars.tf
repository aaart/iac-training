variable "kv_name" {
  type        = string
  description = "Name of the Key Vault."
}

variable "kv_rg" {
  type        = string
  description = "Resource group of the Key Vault."
}

variable "kv_tenant_id" {
  type        = string
  description = "Tenant ID of the Key Vault."
}

variable "kv_secret_permissions" {
  type        = map(list(string))
  default = {}
  description = "Secret permissions to assign to the Key Vault. Key is the object ID of the user or service principal. Value is a list of permissions."
}