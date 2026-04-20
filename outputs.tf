output "firewall_id" {
  description = "Azure Firewall resource ID."
  value       = azurerm_firewall.this.id
}

output "firewall_name" {
  description = "Azure Firewall name."
  value       = azurerm_firewall.this.name
}

output "firewall_private_ip" {
  description = "Primary private IP address of the Azure Firewall."
  value       = try(azurerm_firewall.this.ip_configuration[0].private_ip_address, null)
}

output "firewall_private_ips" {
  description = "Map of private IPs by IP configuration key."
  value = {
    for key, value in local.ip_configurations :
    key => azurerm_firewall.this.ip_configuration[
      index([for config in azurerm_firewall.this.ip_configuration : config.name], value.name)
    ].private_ip_address
  }
}

output "firewall_public_ip_ids" {
  description = "Map of public IP IDs by IP configuration key."
  value = {
    for key, value in local.ip_configurations :
    key => azurerm_firewall.this.ip_configuration[
      index([for config in azurerm_firewall.this.ip_configuration : config.name], value.name)
    ].public_ip_address_id
  }
}
