module "public_ip" {
  source = "github.com/mlinxfeld/terraform-az-fk-public-ip"

  name                = "fk-pip-firewall"
  location            = azurerm_resource_group.fk_rg.location
  resource_group_name = azurerm_resource_group.fk_rg.name
}
