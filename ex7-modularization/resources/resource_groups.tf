module "rg_central_naming" {
  source            = "./../modules/naming"
  resource_type     = "resource_group"
  resource_location = "polandcentral"
  resource_area     = "central"
  resource_index    = "001"
}

resource "azurerm_resource_group" "central" {
  name     = module.rg_central_naming.name
  location = module.rg_central_naming.location
}