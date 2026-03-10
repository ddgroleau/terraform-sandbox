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

variable "sql_admin_username" {
  description = "The MSSQL admin username"
  type        = string
  sensitive   = true
}

variable "sql_admin_password" {
  description = "The MSSQL admin password"
  type        = string
  sensitive   = true
}


variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "vnet_id" {
  description = "Virtual Network ID"
  type        = string
}
