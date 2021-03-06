# Configure the Azure provider
provider "azurerm" {
  features {
    key_vault {
        purge_soft_delete_on_destroy = true
    }
  }
}

# Store state in Azure Blob Storage
terraform {
  backend "azurerm" {
    resource_group_name  = "shared-services"
    storage_account_name = "tomuvstore"
    container_name       = "tstate-apiproxy"
    key                  = "terraform.tfstate"
  }
}
