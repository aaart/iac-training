
resource "github_actions_environment_secret" "secret" {
  for_each          = local.kv_secrets_map
  repository        = local.repository_name_no_owner
  environment       = var.github_repository_environment
  secret_name       = each.value.name
  plaintext_value   = each.value.value
}
