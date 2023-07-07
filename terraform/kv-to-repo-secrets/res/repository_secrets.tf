
resource "github_actions_environment_secret" "secret" {
  for_each          = local.kv_secrets_map
  repository        = var.github_repository_name
  environment       = var.github_repository_environment
  secret_name       = each.value.name
  plaintext_value   = each.value.value
}
