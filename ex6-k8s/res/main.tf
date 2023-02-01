module "kv" {
  source                 = "./00_kv"
  kv_name                = local.kv_name
  kv_rg                  = var.az_resource_group
  kv_tenant_id           = var.tenant_id
  kv_secret_permissions  = {
    "${var.terraforming_identity}" = ["Get", "List", "Set", "Delete", "Purge", "Recover", "Backup", "Restore"]
  } 
}

module "acr" {
  depends_on = [
    module.kv
  ]

  source                 = "./01_acr"
  acr_name               = local.acr_name
  acr_rg                 = var.az_resource_group
  kv_id                  = module.kv.kv_id
}

module "aks" {
  depends_on = [
    module.acr
  ]

  source                      = "./02_aks"
  aks_rg                      = var.az_resource_group
  aks_vnet_name               = local.network.vnet_name
  aks_subnet_name             = local.network.subnet_name
  aks_vnet_address_space      = local.network.address_space
  aks_subnet_address_prefixes = local.network.address_prefixes
}

# resource "azurerm_kubernetes_cluster" "cluster" {
#   name                = local.cluster.name
#   resource_group_name = local.cluster.resource_group_name
#   location            = local.cluster.location
#   dns_prefix          = local.cluster.dns_prefix

#   network_profile {
#     network_plugin    = local.cluster.network_profile.network_plugin
#     network_policy    = local.cluster.network_profile.network_policy
#     load_balancer_sku = local.cluster.network_profile.load_balancer_sku
#   }

#   default_node_pool {
#     name                = local.cluster.system_node_pool.name
#     node_count          = local.cluster.system_node_pool.node_count
#     vm_size             = local.cluster.system_node_pool.vm_size
#     vnet_subnet_id      = azurerm_subnet.cluster_subnet.id
#     enable_auto_scaling = local.cluster.system_node_pool.enable_auto_scaling
    
#   }

#   identity {
#     type = "SystemAssigned"
#   }
# }

# resource "azurerm_key_vault_access_policy" "kv_cluster_node_pool_access" {
#   key_vault_id          = azurerm_key_vault.kv.id
#   tenant_id             = var.tenant_id
#   object_id             = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
#   secret_permissions    = [ "Get", "List" ]
# }

# resource "azurerm_key_vault_secret" "cluster_auth" {
#   key_vault_id        = azurerm_key_vault.kv.id
#   name                = "${azurerm_kubernetes_cluster.cluster.name}-aks2acr-auth"
#   value               = format(
#                             local.cluster.auth_template, 
#                             azurerm_container_registry.acr.name, 
#                             azurerm_container_registry.acr.name, 
#                             azurerm_container_registry.acr.admin_password,
#                             base64encode("${azurerm_container_registry.acr.name}:${azurerm_container_registry.acr.admin_password}"))
# }