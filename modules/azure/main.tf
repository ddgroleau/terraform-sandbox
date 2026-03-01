# Configure Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_region
  tags = {
    Environment = var.environment
    ManagedBy   = var.managed_by
  }
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = [var.virtual_network_CIDR]
  location            = var.resource_group_region
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_resource_group.rg]
  tags = {
    Environment = var.environment
    ManagedBy   = var.managed_by
  }
}
