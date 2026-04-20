module "workload_vm" {
  source = "github.com/mlinxfeld/terraform-az-fk-compute"

  name                = "fk-workload-vm"
  location            = azurerm_resource_group.fk_rg.location
  resource_group_name = azurerm_resource_group.fk_rg.name
  subnet_id           = module.vnet_hub.subnet_ids["fk-subnet-workload"]

  deployment_mode = "vm"
  vm_size         = var.workload_vm_size

  ssh_public_key                = tls_private_key.public_private_key_pair.public_key_openssh
  private_ip_address_allocation = "Static"
  private_ip_address            = var.workload_vm_private_ip
  lb_attachment                 = null

  custom_data = base64encode(<<-EOF
    #cloud-config
    packages:
      - iputils-ping
      - traceroute
      - curl
      - dnsutils
    EOF
  )
}
