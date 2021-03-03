resource "azurerm_public_ip" "gwip" {
  name                = "gwip-${var.name}"
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_application_gateway" "gw" {
  name                = "kube-api-proxy"
  resource_group_name = var.resource_group
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "gwip"
    subnet_id = var.proxy_subnet_id
  }

  frontend_port {
    name = "port443"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "ipconfig"
    public_ip_address_id = azurerm_public_ip.gwip.id
  }

  ssl_certificate {
    name     = "certificate"
    data     = var.pfxdata
    password = var.pfxpassword
  }

  trusted_root_certificate {
    name = "aks"
    data = azurerm_kubernetes_cluster.demo.kube_config.0.cluster_ca_certificate
  }

  backend_address_pool {
    name  = "backend"
    fqdns = [azurerm_kubernetes_cluster.demo.fqdn]
  }

  backend_http_settings {
    name                                = "backend443"
    cookie_based_affinity               = "Disabled"
    path                                = "/"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 60
    pick_host_name_from_backend_address = true
    trusted_root_certificate_names      = ["aks"]
    probe_name                          = "probe"
  }

  probe {
    interval                                  = 60
    name                                      = "probe"
    protocol                                  = "Https"
    path                                      = "/"
    timeout                                   = 5
    unhealthy_threshold                       = 10
    pick_host_name_from_backend_http_settings = true
    match {
      status_code = ["200-401"]
    }
  }

  http_listener {
    name                           = "listen443"
    frontend_ip_configuration_name = "ipconfig"
    frontend_port_name             = "port443"
    protocol                       = "Https"
    ssl_certificate_name           = "certificate"
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "listen443"
    backend_address_pool_name  = "backend"
    backend_http_settings_name = "backend443"
  }
}
