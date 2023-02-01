data "azurerm_resource_group" "rg" {
  name = var.kv_rg
}

resource "azurerm_key_vault" "kv" {
  name                     = var.kv_name
  tenant_id                = var.kv_tenant_id
  sku_name                 = "standard"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  purge_protection_enabled = false
}

resource "azurerm_key_vault_access_policy" "kv_permissions" {
  depends_on = [
    azurerm_key_vault.kv
  ]
  for_each              = var.kv_secret_permissions

  key_vault_id          = azurerm_key_vault.kv.id
  tenant_id             = var.kv_tenant_id
  object_id             = each.key
  secret_permissions    = each.value
}

output "kv_id" {
  value = azurerm_key_vault.kv.id
}