param (
    [Parameter(Mandatory=$true)][string]$AzResourceGroup
    ,[Parameter(Mandatory=$true)][string]$TenantId
    ,[string]$TerraformingIdentity
    ,[switch]$Apply
    ,[switch]$Destroy
    ,[string]$Target = "dev"

    ,[string]$PlanFile = "plan.out"
)

terraform -chdir=res init

if (-not ((terraform -chdir=res workspace list) -match "$Target")) { 
    terraform -chdir=res workspace new $Target
}

if (-not $TerraformingIdentity) {
    $terraformingIdentity =  ((az ad signed-in-user show --query=objectId) ?? (az ad signed-in-user show --query=id)).Trim('"')
}

$terraformingIdentity = $TerraformingIdentity


terraform -chdir=res workspace select $Target
terraform -chdir=res validate
terraform -chdir=res plan -var-file="../tfvars/$Target.tfvars" -var="az_resource_group=$AzResourceGroup" -var="tenant_id=$Tenantid" -var="terraforming_identity=$terraformingIdentity" -out="$PlanFile"


if ($Apply) {
    terraform -chdir=res apply -auto-approve $PlanFile
}

if ($Destroy) {
    terraform -chdir=res destroy -auto-approve -var-file="../tfvars/$Target.tfvars" -var="az_resource_group=$AzResourceGroup" -var="tenant_id=$Tenantid" -var="terraforming_identity=$terraformingIdentity"
}

if (Test-Path $PlanFile) 
{ 
    Remove-Item $PlanFile -Verbose
}
