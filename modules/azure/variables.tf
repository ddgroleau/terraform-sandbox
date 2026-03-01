variable "environment" {
  description = "The Environment tag to apply to resources."
  type        = string
  default     = "sandbox"
}

variable "managed_by" {
  description = "The value for the 'ManagedBy' tag to apply to resources."
  type        = string
  default     = "terraform"
}

variable "resource_group_name" {
  description = "The name of the resource group to create."
  type        = string
  default     = "tf-sandbox-resource-group"
}

variable "resource_group_region" {
  description = "The Azure region where the resource group will be created."
  type        = string
  default     = "westus2"
}

variable "virtual_network_name" {
  description = "The name of the virtual network to create."
  type        = string
  default     = "tf-sandbox-vnet"
}

variable "virtual_network_CIDR" {
  description = "The CIDR block for the virtual network."
  type        = string
  default     = "10.0.0.0/16"
}
