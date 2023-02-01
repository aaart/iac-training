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
