module "kv" {
  source       = "./00_kv"
  kv_name      = local.kv_name
  kv_rg        = var.az_resource_group
  kv_tenant_id = var.tenant_id
  kv_secret_permissions = {
    "${var.terraforming_identity}" = ["Get", "List", "Set", "Delete", "Purge", "Recover", "Backup", "Restore"]
  }
}

module "acr" {
  depends_on = [
    module.kv
  ]

  source   = "./01_acr"
  acr_name = local.acr_name
  acr_rg   = var.az_resource_group
  kv_id    = module.kv.kv_id
}

module "aks" {
  depends_on = [
    module.kv,
    module.acr
  ]

  source                      = "./02_aks"
  aks_rg                      = var.az_resource_group
  aks_kv_id                   = module.kv.kv_id
  aks_tenant_id               = var.tenant_id
  aks_acr_name                = local.acr_name
  aks_acr_password            = module.acr.acr_password
  aks_cluster_name            = local.aks_cluster_name
  aks_vnet_name               = local.network.vnet_name
  aks_subnet_name             = local.network.subnet_name
  aks_vnet_address_space      = local.network.address_space
  aks_subnet_address_prefixes = local.network.address_prefixes
  aks_dns_prefix              = local.network.dns_prefix
}

module "cluster" {
  depends_on = [
    module.aks
  ]
  source = "./03_cluster"

  cluster_full_name                = module.aks.aks_cluster_full_name
}
