#!/bin/bash

terraform -chdir=./cdktf.out/stacks/azurerm \
          validate
terraform -chdir=./cdktf.out/stacks/azurerm \
          plan \
          -out=plan.tfplan \
          -var default_tenant_id=$TENANT_ID \
          -var default_client_id=$TERRAFORM_CLIENT_ID \
          -var default_client_secret=$TERRAFORM_CLIENT_SECRET \
          -var default_subscription_id=$TERRAFORM_SUBSCRIPTION_ID
