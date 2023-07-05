#!/bin/sh

terraform -chdir=./../res \
          init \
          -reconfigure \
          -backend-config=key=iac-training-secrets.tfstate \
          -backend-config=tenant_id=$TENANT_ID \
          -backend-config=subscription_id=$TERRAFORM_SUBSCRIPTION_ID \
          -backend-config=container_name=$TERRAFORM_CONTAINER_NAME \
          -backend-config=storage_account_name=$TERRAFORM_STORAGE_ACCOUNT_NAME \
          -backend-config=resource_group_name=$TERRAFORM_RESOURCE_GROUP \
          -backend-config=client_id=$TERRAFORM_CLIENT_ID \
          -backend-config=client_secret=$TERRAFORM_CLIENT_SECRET