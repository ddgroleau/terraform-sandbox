variable "environment" {
  type    = string
  default = "dev"
}

variable "ssl_cert_password" {
  description = "The SSL Certificate password"
  type        = string
  sensitive   = true
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
