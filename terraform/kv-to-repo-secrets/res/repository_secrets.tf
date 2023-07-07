
resource "github_actions_environment_secret" "secret" {
  for_each          = data.azurerm_key_vault_secret.secrets
  repository        = var.github_repository_name
  environment       = var.github_repository_environment
  secret_name       = each.value.name
  plaintext_value   = each.value.value
}
