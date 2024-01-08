# Terraform Block
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}
# Provider Block
provider "azurerm" {
  features {}
  skip_provider_registration = true
}