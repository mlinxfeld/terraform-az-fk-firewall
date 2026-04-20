module "firewall" {
  source = "../.."

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
      name     = "allow-dns"
      priority = 100
      action   = "Allow"
      rules = [
        {
          name                  = "allow-dns-outbound"
          protocols             = ["UDP", "TCP"]
          source_addresses      = ["10.0.0.0/16"]
          destination_addresses = ["8.8.8.8", "1.1.1.1"]
          destination_ports     = ["53"]
        }
      ]
    }
  ]

  application_rule_collections = [
    {
      name     = "allow-web"
      priority = 200
      action   = "Allow"
      rules = [
        {
          name             = "allow-http-https"
          source_addresses = ["10.0.0.0/16"]
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
