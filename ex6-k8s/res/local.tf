locals {
  
  resource_name_template     = "terraformed%s${var.target_environment}"

  kv_name                    = format(local.resource_name_template, "kv")
  acr_name                   = format(local.resource_name_template, "acr")
  aks_cluster_name           = format(local.resource_name_template, "aks")

  network = {
    vnet_name           = "${local.aks_cluster_name}-vnet"
    subnet_name         = "${local.aks_cluster_name}-subnet"
    address_space       = ["10.100.0.0/16"]
    address_prefixes    = ["10.100.128.0/17"]
    dns_prefix          = local.aks_cluster_name
  }
  
}