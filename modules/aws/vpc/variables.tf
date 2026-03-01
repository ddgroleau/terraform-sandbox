variable "environment" {
  type = string
}

variable "managed_by" {
  type = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "sandbox-vpc"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  description = "The availability zones for the VPC"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "vpc_subnet_cidrs" {
  description = "The CIDR blocks for the VPC subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnet_cidrs" {
  description = "The CIDR blocks for the VPC public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24"]
}

