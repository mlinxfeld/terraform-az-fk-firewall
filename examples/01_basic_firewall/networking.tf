module "vnet_hub" {
  source = "github.com/mlinxfeld/terraform-az-fk-vnet"

  name                = "fk-vnet"
  location            = azurerm_resource_group.fk_rg.location
  resource_group_name = azurerm_resource_group.fk_rg.name
  address_space       = ["10.0.0.0/16"]

  subnets = {
    AzureFirewallSubnet = {
      address_prefixes = ["10.0.1.0/24"]
    }
    fk-subnet-workload = {
      address_prefixes = ["10.0.2.0/24"]
    }
  }
}

module "routing" {
  source = "github.com/mlinxfeld/terraform-az-fk-routing"

  resource_group_name = azurerm_resource_group.fk_rg.name

  route_tables = {
    rt-workload = {
      location = azurerm_resource_group.fk_rg.location

      routes = [
        {
          name           = "default-to-internet-via-firewall"
          address_prefix = "0.0.0.0/0"
          next_hop_type  = "VirtualAppliance"
          next_hop_ip    = module.firewall.firewall_private_ip
        }
      ]

      subnet_ids = [
        module.vnet_hub.subnet_ids["fk-subnet-workload"]
      ]
    }
  }
}
