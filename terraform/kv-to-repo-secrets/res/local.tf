locals {
  repository_name_no_owner = replace(var.github_repository_name, var.github_owner + "/", "")

  kv_secret_names = toset(split(" ", var.kv_secrets))

  kv_secrets_map = {
    for secret in local.kv_secret_names : secret => {
      name = replace(replace(secret, "${local.repository_name_no_owner}---", ""), "-", "_")
      value = data.azurerm_key_vault_secret.secrets[secret].value
    }
  }
}