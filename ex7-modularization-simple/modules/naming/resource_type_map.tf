variable "resource_type_map" {
  type = map(string)
  default = {
    "resource_group"     = "rg"
    "virtual_network"    = "vnet"
  }
}