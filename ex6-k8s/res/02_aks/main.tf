data "azurerm_resource_group" "rg" {  
  name                = var.aks_rg
}

resource "azurerm_virtual_network" "cluster_network" {
  name                = var.aks_vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  address_space       = var.aks_vnet_address_space
}

resource "azurerm_subnet" "cluster_subnet" {
  depends_on = [
    azurerm_virtual_network.cluster_network
  ]

  name                 = var.aks_subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.cluster_network.name
  address_prefixes     = var.aks_subnet_address_prefixes
}

resource "azurerm_kubernetes_cluster" "cluster" {
  depends_on = [
    azurerm_subnet.cluster_subnet
  ]

  name                = var.aks_cluster_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  dns_prefix          = var.aks_dns_prefix

  network_profile {
    network_plugin    = "azure"
    network_policy    = "calico"
    load_balancer_sku = "standard"
  }

  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_B4ms"
    vnet_subnet_id      = azurerm_subnet.cluster_subnet.id
    enable_auto_scaling = false
    
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_key_vault_access_policy" "kv_cluster_node_pool_access" {
  depends_on = [
    azurerm_kubernetes_cluster.cluster
  ]
  key_vault_id          = var.aks_kv_id
  tenant_id             = var.aks_tenant_id
  object_id             = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
  secret_permissions    = [ "Get", "List" ]
}

resource "azurerm_key_vault_secret" "cluster_auth" {
  depends_on = [
    azurerm_key_vault_access_policy.kv_cluster_node_pool_access
  ]

  key_vault_id        = var.aks_kv_id
  name                = "${azurerm_kubernetes_cluster.cluster.name}-aks2acr-auth"
  value               = format(
                            "{\"auths\":{\"%s.azurecr.io\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"email@mail.com\",\"auth\":\"%s\"}}}", 
                            var.aks_acr_name,
                            var.aks_acr_name,
                            var.aks_acr_password,
                            base64encode("${var.aks_acr_name}:${var.aks_acr_password}"))
}

output "aks_host_url" {
  value = azurerm_kubernetes_cluster.cluster.kube_config[0].host
}

output "aks_cluster_full_name" {
  value = trim(trim(azurerm_kubernetes_cluster.cluster.kube_config[0].host, "https://"), ":443")
}

output "aks_client_certificate" {
  value = azurerm_kubernetes_cluster.cluster.kube_config[0].client_certificate
}

output "aks_client_key" {
  value = azurerm_kubernetes_cluster.cluster.kube_config[0].client_key
}

output "aks_ca_certificate" {
  value = azurerm_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate
}