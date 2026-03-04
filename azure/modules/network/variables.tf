variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
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

variable "private_security_group_id" {
  description = "The ID of the private network security group"
  type        = string
}

variable "ssl_cert_password" {
  description = "The SSL Certificate password"
  type        = string
  sensitive   = true
}
