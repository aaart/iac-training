data "azurerm_resource_group" "rg" {  
  name                = var.acr_rg
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  admin_enabled       = true
  sku                 = "Basic"
}

resource "azurerm_key_vault_secret" "acr_password" {
  depends_on          = [
    azurerm_container_registry.acr
  ]

  key_vault_id        = var.kv_id
  name                = "${azurerm_container_registry.acr.name}-password"
  value               = azurerm_container_registry.acr.admin_password
}

output "acr_password" {
  value = azurerm_container_registry.acr.admin_password
}
