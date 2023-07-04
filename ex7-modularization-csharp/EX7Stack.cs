using System.Collections.Generic;
using EX7.Modularization.CSharp.Enums;
using Constructs;
using HashiCorp.Cdktf;
using HashiCorp.Cdktf.Providers.Azurerm.Provider;
using HashiCorp.Cdktf.Providers.Azurerm.ResourceGroup;
using HashiCorp.Cdktf.Providers.Azurerm.Subnet;
using HashiCorp.Cdktf.Providers.Azurerm.VirtualNetwork;

namespace EX7.Modularization.CSharp
{
    class EX7Stack : TerraformStack
    {
        private static string GetResourceName(ResourceType resourceType, Location resourceLocation, string resourceArea, uint resourceIndex)
        {
            var typeAbbrevations = new Dictionary<ResourceType, string>
            {
                { ResourceType.ResourceGroup, "rg" },
                { ResourceType.VirtualNetwork, "vnet" }
            };

            var locationAbbrevations = new Dictionary<Location, string>
            {
                { Location.PolandCentral, "plc" }
            };

            return $"{typeAbbrevations[resourceType]}aaart{resourceArea}{locationAbbrevations[resourceLocation]}{resourceIndex.ToString("D3")}";
        }
        
        public EX7Stack(Construct scope, string id)
            : base(scope, id)
        {
            new AzurermBackend(
                scope,
                new AzurermBackendConfig
                {
                    TenantId = "ToBeApplied",
                    SubscriptionId = "ToBeApplied",
                    ResourceGroupName = "ToBeApplied",
                    StorageAccountName = "ToBeApplied",
                    ContainerName = "ToBeApplied",
                    Key = "ToBeApplied",
                    ClientId = "ToBeApplied",
                    ClientSecret = "ToBeApplied"
                });

            new TerraformVariable(scope, "default_subscription_id", new TerraformVariableConfig
            {
                Type = "string"
            });

            new TerraformVariable(scope, "default_tenant_id", new TerraformVariableConfig
            {
                Type = "string"
            });

            new TerraformVariable(scope, "default_client_id", new TerraformVariableConfig
            {
                Type = "string"
            });

            new TerraformVariable(scope, "default_client_secret", new TerraformVariableConfig
            {
                Type = "string"
            });

            new AzurermProvider(scope, "azurerm", new AzurermProviderConfig { Features = new AzurermProviderFeatures() });
            var centralRg = new ResourceGroup(scope, "central", new ResourceGroupConfig
            {
                Name = GetResourceName(ResourceType.ResourceGroup, Location.PolandCentral, "central", 1),
                Location = Location.PolandCentral.ToString()
            });
            
            var centralVnet = new VirtualNetwork(scope, "hub",new VirtualNetworkConfig
            {
                Name = GetResourceName(ResourceType.VirtualNetwork, Location.PolandCentral, "central", 1),
                Location = Location.PolandCentral.ToString(),
                ResourceGroupName = centralRg.Name,
                AddressSpace = new []{ "10.0.0.0/24" }
            });

            new Subnet(scope, "main", new SubnetConfig
            {
                Name = "MainSubnet",
                ResourceGroupName = centralRg.Name,
                VirtualNetworkName = centralVnet.Name,
                AddressPrefixes = new []{ "10.0.0.0/27" }
            });
        }
    }
}