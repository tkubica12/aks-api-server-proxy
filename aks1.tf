resource "azurerm_resource_group" "aks1" {
  name     = "aks1-rg"
  location = "westeurope"
}

module "aks1" {
  source = "./modules/aks"

  resource_group  = azurerm_resource_group.aks1.name
  location        = azurerm_resource_group.aks1.location
  name            = "aks1"
  aks_subnet_id   = azurerm_subnet.aks1.id
  proxy_subnet_id = azurerm_subnet.proxy1.id
  admin_group_id  = "2f003f7d-d039-4f87-8575-c2d45d091c2c"
  pfxdata         = filebase64("cert.pfx")
  pfxpassword     = var.pfxpassword
}

resource "azurerm_dns_a_record" "example" {
  name                = "aks1"
  zone_name           = azurerm_dns_zone.dns.name
  resource_group_name = azurerm_resource_group.dns.name
  ttl                 = 300
  records             = [module.aks1.ip]
}