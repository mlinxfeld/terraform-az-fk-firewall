variable "name" {
  description = "Name of the Azure Firewall."
  type        = string
}

variable "location" {
  description = "Azure region where the firewall is deployed."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "sku_name" {
  description = "Azure Firewall SKU name."
  type        = string
  default     = "AZFW_VNet"
}

variable "sku_tier" {
  description = "Azure Firewall SKU tier."
  type        = string
  default     = "Standard"
}

variable "threat_intel_mode" {
  description = "Threat intelligence mode for the firewall."
  type        = string
  default     = "Alert"
}

variable "firewall_policy_id" {
  description = "Optional Azure Firewall Policy ID to associate with the firewall."
  type        = string
  default     = null
}

variable "dns_servers" {
  description = "Optional custom DNS servers for the firewall."
  type        = list(string)
  default     = null
}

variable "ip_configurations" {
  description = "Map of Azure Firewall IP configurations."
  type = map(object({
    name                 = optional(string)
    subnet_id            = optional(string)
    public_ip_address_id = optional(string)
    private_ip_address   = optional(string)
  }))
}

variable "network_rule_collections" {
  description = "Optional network rule collections created directly on the firewall."
  type = list(object({
    name     = string
    priority = number
    action   = string
    rules = list(object({
      name                  = string
      protocols             = list(string)
      source_addresses      = optional(list(string), [])
      destination_addresses = optional(list(string), [])
      destination_ports     = list(string)
      destination_fqdns     = optional(list(string), [])
    }))
  }))
  default = []
}

variable "application_rule_collections" {
  description = "Optional application rule collections created directly on the firewall."
  type = list(object({
    name     = string
    priority = number
    action   = string
    rules = list(object({
      name             = string
      source_addresses = list(string)
      target_fqdns     = list(string)
      protocols = list(object({
        type = string
        port = number
      }))
    }))
  }))
  default = []
}

variable "nat_rule_collections" {
  description = "Optional NAT rule collections created directly on the firewall."
  type = list(object({
    name     = string
    priority = number
    action   = string
    rules = list(object({
      name                  = string
      protocols             = list(string)
      source_addresses      = list(string)
      destination_addresses = list(string)
      destination_ports     = list(string)
      translated_address    = string
      translated_port       = string
    }))
  }))
  default = []
}

variable "tags" {
  description = "Tags applied to resources."
  type        = map(string)
  default     = {}
}
