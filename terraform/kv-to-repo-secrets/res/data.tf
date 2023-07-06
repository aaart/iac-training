data "azurerm_key_vault" "kv" {
  name                = var.kv_name
  resource_group_name = var.kv_resource_group_name
}

data "azurerm_key_vault_secret" "secrets" {
  for_each     = local.kv_secret_names
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = each.key
}
