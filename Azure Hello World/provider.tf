# Terraform configuration file for Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}



# Configure the Azure Provider
provider "azurerm" {
  features {}
}