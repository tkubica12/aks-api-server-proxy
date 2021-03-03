resource "azurerm_resource_group" "net" {
  name     = "networking-rg"
  location = "West Europe"
}

# net network
resource "azurerm_virtual_network" "net" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.net.location
  resource_group_name = azurerm_resource_group.net.name
}

resource "azurerm_subnet" "aks1" {
  name                 = "aks1"
  resource_group_name  = azurerm_resource_group.net.name
  virtual_network_name = azurerm_virtual_network.net.name
  address_prefixes     = ["10.0.0.0/22"]
}

resource "azurerm_subnet" "aks2" {
  name                 = "aks2"
  resource_group_name  = azurerm_resource_group.net.name
  virtual_network_name = azurerm_virtual_network.net.name
  address_prefixes     = ["10.0.4.0/22"]
}

resource "azurerm_subnet" "proxy1" {
  name                 = "proxy1"
  resource_group_name  = azurerm_resource_group.net.name
  virtual_network_name = azurerm_virtual_network.net.name
  address_prefixes     = ["10.0.254.0/29"]
}

resource "azurerm_subnet" "proxy2" {
  name                 = "proxy2"
  resource_group_name  = azurerm_resource_group.net.name
  virtual_network_name = azurerm_virtual_network.net.name
  address_prefixes     = ["10.0.254.8/29"]
}

