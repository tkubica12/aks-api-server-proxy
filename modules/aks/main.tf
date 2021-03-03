# Providers
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

# Configure the Azure provider
provider "azurerm" {
  features {}
}