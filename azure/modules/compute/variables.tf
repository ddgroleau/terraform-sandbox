variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resource group"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for AKS nodes"
  type        = list(string)
}

variable "app_gateway_id" {
  description = "Application Gateway resource ID for AGIC integration"
  type        = string
}

variable "vnet_id" {
  description = "Virtual Network ID for network permissions"
  type        = string
}
