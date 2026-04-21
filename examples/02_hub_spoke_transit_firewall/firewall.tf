module "firewall" {
  source = "git::https://github.com/mlinxfeld/terraform-az-fk-firewall.git?ref=v0.2.0"

  name                = "fk-azure-firewall"
  location            = azurerm_resource_group.fk_rg.location
  resource_group_name = azurerm_resource_group.fk_rg.name
  sku_tier            = var.firewall_sku_tier

  ip_configurations = {
    primary = {
      subnet_id            = module.vnet_hub.subnet_ids["AzureFirewallSubnet"]
      public_ip_address_id = module.public_ip.id
    }
  }

  network_rule_collections = [
    {
      name     = "allow-east-west"
      priority = 100
      action   = "Allow"
      rules = [
        {
          name                  = "spoke1-to-spoke2"
          protocols             = ["Any"]
          source_addresses      = ["10.1.0.0/16"]
          destination_addresses = ["10.2.0.0/16"]
          destination_ports     = ["*"]
        },
        {
          name                  = "spoke2-to-spoke1"
          protocols             = ["Any"]
          source_addresses      = ["10.2.0.0/16"]
          destination_addresses = ["10.1.0.0/16"]
          destination_ports     = ["*"]
        }
      ]
    }
  ]

  application_rule_collections = [
    {
      name     = "allow-web-egress"
      priority = 200
      action   = "Allow"
      rules = [
        {
          name             = "spokes-web"
          source_addresses = ["10.1.0.0/16", "10.2.0.0/16"]
          target_fqdns     = ["*"]
          protocols = [
            {
              type = "Http"
              port = 80
            },
            {
              type = "Https"
              port = 443
            }
          ]
        }
      ]
    }
  ]
}
