#!/bin/bash

terraform init -reconfigure \
               -backend-config=key=ex7.tfstate \
               -backend-config=container_name=$TERRAFORM_CONTAINER_NAME \
               -backend-config=storage_account_name=$TERRAFORM_STORAGE_ACCOUNT_NAME \
               -backend-config=resource_group_name=$TERRAFORM_RESOURCE_GROUP