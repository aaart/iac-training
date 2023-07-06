locals {
  kv_secret_names = toset(split(" ", var.kv_secrets))
}