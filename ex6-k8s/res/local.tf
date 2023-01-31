locals {
  kv = {
    tenant_id                = var.tenant_id
    name                     = "terraformed-kv"
    sku_name                 = "standard"
    resource_group_name      = data.azurerm_resource_group.rg.name
    location                 = data.azurerm_resource_group.rg.location
    purge_protection_enabled = false
  }

  acr = {
    name                = "terraformedacr"
    resource_group_name = data.azurerm_resource_group.rg.name
    location            = data.azurerm_resource_group.rg.location
    admin_enabled       = true
    sku                 = "Basic"
  }

  cluster = {
    name                = "terraformed-cluster"
    dns_prefix          = "terraformed-cluster"
    resource_group_name = data.azurerm_resource_group.rg.name
    location            = data.azurerm_resource_group.rg.location

    network_profile = {
      network_plugin    = "azure"
      network_policy    = "calico"
      load_balancer_sku = "standard"
    }

    system_node_pool = {
      name                = "default"
      node_count          = 1
      vm_size             = "Standard_B4ms"
      enable_auto_scaling = false
    }

    auth_template         = "{\"auths\":{\"%s.azurecr.io\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"email@mail.com\",\"auth\":\"%s\"}}}"
  }

  network = {
    vnet_name           = "${local.cluster.name}-network"
    subnet_name         = "${local.cluster.name}-subnet"
    resource_group_name = data.azurerm_resource_group.rg.name
    location            = data.azurerm_resource_group.rg.location
    address_space       = ["10.100.0.0/16"]
    address_prefixes    = ["10.100.128.0/17"]
  }

  cluster_node_pool = {
    name       = "node-pool"
    vm_size    = "Standard_B4ms"
    node_count = 1
  }
}