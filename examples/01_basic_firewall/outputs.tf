output "hub_vnet_id" {
  value = module.vnet_hub.vnet_id
}

output "workload_vm_id" {
  value = module.workload_vm.vm_id
}

output "workload_vm_private_ip" {
  value = module.workload_vm.vm_private_ip
}

output "firewall_id" {
  value = module.firewall.firewall_id
}

output "firewall_name" {
  value = module.firewall.firewall_name
}

output "firewall_private_ip" {
  value = module.firewall.firewall_private_ip
}

output "firewall_public_ip_id" {
  value = module.public_ip.id
}

output "route_tables" {
  value = module.routing.route_table_ids
}
