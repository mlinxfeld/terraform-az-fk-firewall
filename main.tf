locals {
  ip_configurations = {
    for key, value in var.ip_configurations : key => merge(
      {
        name                 = key
        subnet_id            = null
        public_ip_address_id = null
        private_ip_address   = null
      },
      value,
      {
        name = coalesce(try(value.name, null), key)
      }
    )
  }

  network_rule_collections = {
    for collection in var.network_rule_collections : collection.name => collection
  }

  application_rule_collections = {
    for collection in var.application_rule_collections : collection.name => collection
  }

  nat_rule_collections = {
    for collection in var.nat_rule_collections : collection.name => collection
  }
}

resource "azurerm_firewall" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  threat_intel_mode   = var.threat_intel_mode
  firewall_policy_id  = var.firewall_policy_id
  dns_servers         = var.dns_servers
  tags                = var.tags

  dynamic "ip_configuration" {
    for_each = local.ip_configurations

    content {
      name                 = ip_configuration.value.name
      subnet_id            = ip_configuration.value.subnet_id
      public_ip_address_id = ip_configuration.value.public_ip_address_id
      private_ip_address   = ip_configuration.value.private_ip_address
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "this" {
  for_each = local.network_rule_collections

  name                = each.value.name
  azure_firewall_name = azurerm_firewall.this.name
  resource_group_name = var.resource_group_name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each = each.value.rules

    content {
      name                  = rule.value.name
      protocols             = rule.value.protocols
      source_addresses      = rule.value.source_addresses
      destination_addresses = rule.value.destination_addresses
      destination_ports     = rule.value.destination_ports
      destination_fqdns     = rule.value.destination_fqdns
    }
  }
}

resource "azurerm_firewall_application_rule_collection" "this" {
  for_each = local.application_rule_collections

  name                = each.value.name
  azure_firewall_name = azurerm_firewall.this.name
  resource_group_name = var.resource_group_name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each = each.value.rules

    content {
      name             = rule.value.name
      source_addresses = rule.value.source_addresses
      target_fqdns     = rule.value.target_fqdns

      dynamic "protocol" {
        for_each = rule.value.protocols

        content {
          type = protocol.value.type
          port = protocol.value.port
        }
      }
    }
  }
}

resource "azurerm_firewall_nat_rule_collection" "this" {
  for_each = local.nat_rule_collections

  name                = each.value.name
  azure_firewall_name = azurerm_firewall.this.name
  resource_group_name = var.resource_group_name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each = each.value.rules

    content {
      name                  = rule.value.name
      protocols             = rule.value.protocols
      source_addresses      = rule.value.source_addresses
      destination_addresses = rule.value.destination_addresses
      destination_ports     = rule.value.destination_ports
      translated_address    = rule.value.translated_address
      translated_port       = rule.value.translated_port
    }
  }
}
