resource "azurerm_resource_group" "dns" {
  name     = "dns-zones-rg"
  location = "West Europe"
}

resource "azurerm_dns_zone" "dns" {
  name                = var.zone
  resource_group_name = azurerm_resource_group.dns.name
}