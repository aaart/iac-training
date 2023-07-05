#!/bin/sh

terraform -chdir=./../res \
          validate
terraform -chdir=./../res \
          plan \
          -out=plan.tfplan \
          -var azurerm_tenant_id=$UMGMT_TENANT_ID \
          -var azurerm_client_id=$UMGMT_CLIENT_ID \
          -var azurerm_client_secret=$UMGMT_CLIENT_SECRET \
          -var azurerm_subscription_id=$TERRAFORM_CLIENT_SECRET \
          -var kv_name=$UMGMT_KV_REPOSITORY_SECRETS \
          -var kv_resource_group_name=$UMGMT_KV_REPOSITORY_SECRETS_RG_NAME \
          -var kv_secrets=$WRKFLW_SECRETS

