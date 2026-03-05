terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.62.1"
    }
  }

  required_version = ">= 1.14.0"
}

provider "azurerm" {
  features {}
}

module "foundation" {
  source = "../../modules/foundation"

  environment             = var.environment
  resource_group_location = "westus2"
}

module "security" {
  source = "../../modules/security"

  environment             = var.environment
  security_group_name     = "${var.environment}-nsg"
  resource_group_name     = module.foundation.resource_group_name
  resource_group_location = module.foundation.resource_group_location
}

module "network" {
  source = "../../modules/network"

  environment          = var.environment
  virtual_network_name = "${var.environment}-vnet"

  resource_group_name       = module.foundation.resource_group_name
  resource_group_location   = module.foundation.resource_group_location
  private_security_group_id = module.security.private_security_group_id
  ssl_cert_password         = var.ssl_cert_password
}

module "compute" {
  source = "../../modules/compute"

  environment             = var.environment
  resource_group_name     = module.foundation.resource_group_name
  resource_group_location = module.foundation.resource_group_location

  private_subnet_ids = module.network.private_subnet_ids
  app_gateway_id     = module.network.app_gateway_id
  vnet_id            = module.network.vnet_id
}
