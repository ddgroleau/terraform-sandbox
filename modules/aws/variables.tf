variable "environment" {
  description = "The environment name"
  type        = string
  default     = "sandbox"
}

variable "managed_by" {
  description = "The name of the managed by tag"
  type        = string
  default     = "terraform"
}

variable "aws_region" {
  description = "The AWS region name"
  type        = string
  default     = "us-west-2"
}

variable "aws_ami_owner" {
  description = "The owner of the AMI resource"
  type        = string
  default     = "099720109477"
}

variable "aws_ami_name_filter" {
  description = "The name filter for the AMI resource"
  type        = string
  default     = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
}

variable "aws_app_server_instance_type" {
  description = "The instance type for the app server"
  type        = string
  default     = "t2.nano"
}

variable "aws_app_server_name" {
  description = "The name of the app server"
  type        = string
  default     = "sandbox-app-server"
}
