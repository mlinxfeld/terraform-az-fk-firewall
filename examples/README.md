# Azure Firewall with Terraform/OpenTofu - Training Examples

This directory contains the currently published example for the **terraform-az-fk-firewall** module.
The first release focuses on a practical Azure Firewall deployment with a routed workload subnet.

These examples are part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/)** and are used across Azure and multicloud courses covering networking, security, and architecture fundamentals.

---

## Published Example

| Example | Title | Key Topics |
|:-------:|:------|:-----------|
| 01 | **Basic Azure Firewall** | Azure Firewall, `AzureFirewallSubnet`, public IP, basic network and application rules |

---

## How to Use

The example directory contains:
- Terraform/OpenTofu configuration (`.tf`)
- A focused `README.md` explaining the goal of the example
- A minimal, runnable architecture

To run an example:

```bash
cd examples/01_basic_firewall
tofu init
tofu plan
tofu apply
```

---

## Design Principles

- One example = one architectural goal
- No unused or placeholder resources
- Clear separation of concerns (firewall, networking, routing, compute)
- Examples designed to integrate with other modules such as VNet, Routing, Public IP, and Compute

---

## Related Resources

- [FoggyKitchen Azure Firewall Module (terraform-az-fk-firewall)](../)
- [FoggyKitchen Azure Routing Module (terraform-az-fk-routing)](https://github.com/mlinxfeld/terraform-az-fk-routing)
- [FoggyKitchen Azure VNet Module (terraform-az-fk-vnet)](https://github.com/mlinxfeld/terraform-az-fk-vnet)
- [FoggyKitchen Azure VNet Peering Module (terraform-az-fk-vnet-peering)](https://github.com/mlinxfeld/terraform-az-fk-vnet-peering)
- [FoggyKitchen Azure Compute Module (terraform-az-fk-compute)](https://github.com/mlinxfeld/terraform-az-fk-compute)

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.  
See [LICENSE](../LICENSE) for details.

---

© 2026 FoggyKitchen.com - *Cloud. Code. Clarity.*
