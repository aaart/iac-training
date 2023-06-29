resource "azurerm_virtual_network" "hub" {
  name                = "vnetaaartcentral001"
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.central.location
  resource_group_name = azurerm_resource_group.central.name
}