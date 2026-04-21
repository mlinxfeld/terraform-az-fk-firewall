# terraform-az-fk-firewall

This repository contains a reusable **Terraform / OpenTofu module** and practical examples for deploying **Azure Firewall** as a dedicated network security and egress layer in Azure.

It is part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses/azure-fundamentals-terraform-course/)** and is designed as a **clean, composable firewall building block** that fits into Azure network security architectures.

---

## Purpose

The goal of this module is to provide a **clear, educational, and architecture-aware reference implementation** for Azure Firewall:

- Focused on **Azure Firewall**, IP configuration, and rule collections
- Explicit inputs and outputs, with no hidden dependencies
- Designed to integrate cleanly with:
  - Azure VNets and subnets
  - Azure route tables
  - VNet peering
  - Centralized outbound egress designs

This is **not** a full landing zone or opinionated platform module.  
It is a **learning-first, building-block module**.

---

## What the Module Does

Depending on configuration, the module can create:

- Azure Firewall
- One or more Azure Firewall IP configurations
- Network rule collections
- Application rule collections
- NAT rule collections

The module intentionally does **not** create:

- Virtual Networks or subnets
- Route tables
- Network Security Groups
- Virtual Machines
- VNet peering
- Public IP resources, which can be modeled separately with `terraform-az-fk-public-ip`
- Log Analytics workspaces

Each of those concerns belongs in its **own dedicated module**.

---

## Common Use Cases

This module is intended for firewall-focused building blocks in Azure network designs, including:

- Basic routed egress for a workload subnet, where `0.0.0.0/0` points to the Azure Firewall private IP
- Centralized outbound inspection from multiple spoke VNets through a firewall deployed in the hub VNet
- East-west spoke-to-spoke inspection in hub-and-spoke topologies, where spoke route tables use `VirtualAppliance` next hops
- NAT and application/network rule collection examples that can be composed with dedicated VNet, Peering, Routing, Public IP, and Compute modules

See [`examples/02_hub_spoke_transit_firewall`](./examples/02_hub_spoke_transit_firewall) for a complete hub-and-spoke transit-firewall pattern with centralized egress.

---

## Repository Structure

```bash
terraform-az-fk-firewall/
├── examples/
│   ├── 01_basic_firewall/
│   ├── 02_hub_spoke_transit_firewall/
│   └── README.md
├── main.tf
├── inputs.tf
├── outputs.tf
├── versions.tf
├── LICENSE
└── README.md
```

---

## Example Usage

```hcl
module "public_ip" {
  source = "git::https://github.com/mlinxfeld/terraform-az-fk-public-ip.git?ref=v0.1.0"

  name                = "fk-pip-firewall"
  location            = "westeurope"
  resource_group_name = "fk-rg"
}

module "firewall" {
  source = "git::https://github.com/mlinxfeld/terraform-az-fk-firewall.git?ref=v0.2.0"

  name                = "fk-azure-firewall"
  location            = "westeurope"
  resource_group_name = "fk-rg"

  ip_configurations = {
    primary = {
      subnet_id            = module.vnet.subnet_ids["AzureFirewallSubnet"]
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
        }
      ]
    }
  ]
}
```

---

## Module Inputs

| Variable | Description |
|------|-------------|
| `name` | Name of the Azure Firewall |
| `location` | Azure region |
| `resource_group_name` | Name of the Azure resource group |
| `ip_configurations` | Map of Azure Firewall IP configurations |
| `sku_name` | Azure Firewall SKU name |
| `sku_tier` | Azure Firewall SKU tier |
| `firewall_policy_id` | Optional Azure Firewall Policy ID |
| `dns_servers` | Optional custom DNS servers |
| `network_rule_collections` | Optional network rule collections |
| `application_rule_collections` | Optional application rule collections |
| `nat_rule_collections` | Optional NAT rule collections |
| `tags` | Optional tags applied to resources |

### `ip_configurations` object schema

```hcl
ip_configurations = {
  primary = {
    subnet_id            = "/subscriptions/.../subnets/AzureFirewallSubnet"
    public_ip_address_id = "/subscriptions/.../publicIPAddresses/fk-pip-firewall"
  }
}
```

---

## Outputs

| Output | Description |
|------|-------------|
| `firewall_id` | Azure Firewall resource ID |
| `firewall_name` | Azure Firewall name |
| `firewall_private_ip` | Primary private IP |
| `firewall_private_ips` | Private IPs by configuration key |
| `firewall_public_ip_ids` | Public IP IDs by configuration key |

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](LICENSE) for details.

---

© 2026 FoggyKitchen.com — Cloud. Code. Clarity.
