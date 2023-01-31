resource "azurerm_key_vault" "kv" {
  name                     = local.kv.name
  tenant_id                = local.kv.tenant_id
  sku_name                 = local.kv.sku_name
  resource_group_name      = local.kv.resource_group_name
  location                 = local.kv.location
  purge_protection_enabled = local.kv.purge_protection_enabled
}

resource "azurerm_key_vault_access_policy" "kv_terraforming_identity_permissions" {
  key_vault_id          = azurerm_key_vault.kv.id
  tenant_id             = var.tenant_id
  object_id             = var.terraforming_identity
  secret_permissions    = ["Get", "List", "Set", "Delete", "Purge", "Recover", "Backup", "Restore"]
}

resource "azurerm_container_registry" "acr" {
  name                = local.acr.name
  resource_group_name = local.acr.resource_group_name
  location            = local.acr.location
  admin_enabled       = local.acr.admin_enabled
  sku                 = local.acr.sku
}

resource "azurerm_key_vault_secret" "acr_password" {
  key_vault_id        = azurerm_key_vault.kv.id
  name                = "${azurerm_container_registry.acr.name}-password"
  value               = azurerm_container_registry.acr.admin_password
}

resource "azurerm_virtual_network" "cluster_network" {
  name                = local.network.vnet_name
  resource_group_name = local.network.resource_group_name
  location            = local.network.location
  address_space       = local.network.address_space
}

resource "azurerm_subnet" "cluster_subnet" {
  name                 = local.network.subnet_name
  resource_group_name  = local.network.resource_group_name
  virtual_network_name = azurerm_virtual_network.cluster_network.name
  address_prefixes     = local.network.address_prefixes
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = local.cluster.name
  resource_group_name = local.cluster.resource_group_name
  location            = local.cluster.location
  dns_prefix          = local.cluster.dns_prefix

  network_profile {
    network_plugin    = local.cluster.network_profile.network_plugin
    network_policy    = local.cluster.network_profile.network_policy
    load_balancer_sku = local.cluster.network_profile.load_balancer_sku
  }

  default_node_pool {
    name                = local.cluster.system_node_pool.name
    node_count          = local.cluster.system_node_pool.node_count
    vm_size             = local.cluster.system_node_pool.vm_size
    vnet_subnet_id      = azurerm_subnet.cluster_subnet.id
    enable_auto_scaling = local.cluster.system_node_pool.enable_auto_scaling
    
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_key_vault_access_policy" "kv_cluster_node_pool_access" {
  key_vault_id          = azurerm_key_vault.kv.id
  tenant_id             = var.tenant_id
  object_id             = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
  secret_permissions    = [ "Get", "List" ]
}

resource "azurerm_key_vault_secret" "cluster_auth" {
  key_vault_id        = azurerm_key_vault.kv.id
  name                = "${azurerm_kubernetes_cluster.cluster.name}-aks2acr-auth"
  value               = format(
                            local.cluster.auth_template, 
                            azurerm_container_registry.acr.name, 
                            azurerm_container_registry.acr.name, 
                            azurerm_container_registry.acr.admin_password,
                            base64encode("${azurerm_container_registry.acr.name}:${azurerm_container_registry.acr.admin_password}"))
}