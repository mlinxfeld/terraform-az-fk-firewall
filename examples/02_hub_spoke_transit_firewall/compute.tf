# Test VM in Spoke1
module "spoke1_vm" {
  source = "github.com/mlinxfeld/terraform-az-fk-compute"

  name                = "fk-spoke1-vm"
  location            = azurerm_resource_group.fk_rg.location
  resource_group_name = azurerm_resource_group.fk_rg.name
  subnet_id           = module.vnet_spoke1.subnet_ids["fk-subnet-spoke1"]

  deployment_mode = "vm"
  vm_size         = var.spoke_vm_size

  ssh_public_key                = tls_private_key.public_private_key_pair.public_key_openssh
  private_ip_address_allocation = "Static"
  private_ip_address            = var.spoke1_vm_private_ip
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

# Test VM in Spoke2
module "spoke2_vm" {
  source = "github.com/mlinxfeld/terraform-az-fk-compute"

  name                = "fk-spoke2-vm"
  location            = azurerm_resource_group.fk_rg.location
  resource_group_name = azurerm_resource_group.fk_rg.name
  subnet_id           = module.vnet_spoke2.subnet_ids["fk-subnet-spoke2"]

  deployment_mode = "vm"
  vm_size         = var.spoke_vm_size

  ssh_public_key                = tls_private_key.public_private_key_pair.public_key_openssh
  private_ip_address_allocation = "Static"
  private_ip_address            = var.spoke2_vm_private_ip
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
