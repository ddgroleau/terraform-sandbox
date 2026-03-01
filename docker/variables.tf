variable "external_nginx_port" {
  description = "The external port to map to the nginx container"
  type        = number
  default     = 9090
}

variable "container_name" {
  description = "The name of the Docker container"
  type        = string
  default     = "tutorial"
}
