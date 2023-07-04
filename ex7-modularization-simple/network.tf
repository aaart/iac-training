module "vnet_central_naming" {
  source            = "./modules/naming"
  resource_type     = "virtual_network"
  resource_location = azurerm_resource_group.central.location
  resource_area     = "central"
  resource_index    = "001"
}

resource "azurerm_virtual_network" "hub" {
  name                = module.vnet_central_naming.name
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.central.location
  resource_group_name = azurerm_resource_group.central.name
}

resource "azurerm_subnet" "main" {
  name                 = "MainSubnet"
  resource_group_name  = azurerm_resource_group.central.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.0.0/27"]
}