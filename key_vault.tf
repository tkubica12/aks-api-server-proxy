# data "azurerm_client_config" "current" {}

# resource "azurerm_key_vault" "gw" {
#   name                        = "tomaskubicavault8"
#   location                    = azurerm_resource_group.net.location
#   resource_group_name         = azurerm_resource_group.net.name
#   enabled_for_disk_encryption = true
#   tenant_id                   = data.azurerm_client_config.current.tenant_id
#   soft_delete_retention_days  = 7
#   purge_protection_enabled    = false

#   sku_name = "standard"

#   access_policy {
#     tenant_id = data.azurerm_client_config.current.tenant_id
#     object_id = data.azurerm_client_config.current.object_id

#     certificate_permissions = [
#       "create",
#       "delete",
#       "deleteissuers",
#       "get",
#       "getissuers",
#       "import",
#       "list",
#       "listissuers",
#       "managecontacts",
#       "manageissuers",
#       "setissuers",
#       "update",
#     ]

#     key_permissions = [
#       "Get",
#     ]

#     secret_permissions = [
#       "Get",
#     ]

#     storage_permissions = [
#       "Get",
#     ]
#   }
# }

# resource "azurerm_key_vault_certificate" "gw" {
#   name         = "imported-cert"
#   key_vault_id = azurerm_key_vault.gw.id

#   certificate {
#     contents = filebase64("cert.pfx")
#     password = var.pfxpassword
#   }

#   certificate_policy {
#     issuer_parameters {
#       name = "Self"
#     }

#     key_properties {
#       exportable = true
#       key_size   = 2048
#       key_type   = "RSA"
#       reuse_key  = false
#     }

#     secret_properties {
#       content_type = "application/x-pkcs12"
#     }
#   }
# }