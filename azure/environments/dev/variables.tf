variable "environment" {
  type    = string
  default = "dev"
}

variable "ssl_cert_password" {
  description = "The SSL Certificate password"
  type        = string
  sensitive   = true
}
