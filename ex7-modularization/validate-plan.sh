#!/bin/bash

terraform validate
terraform plan -out=plan.tfplan \
               -var-file=./tfvars/dev.tfvars \
               -var default_tenant_id=$TENANT_ID \
               -var default_client_id=$TERRAFORM_CLIENT_ID \
               -var default_client_secret=$TERRAFORM_CLIENT_SECRET \
               -var default_subscription_id=$TERRAFORM_SUBSCRIPTION_ID
