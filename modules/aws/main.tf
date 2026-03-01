provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source      = "./vpc"
  environment = var.environment
  managed_by  = var.managed_by
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.aws_ami_name_filter]
  }
  owners = [var.aws_ami_owner]
  tags = {
    Environment = var.environment
    ManagedBy   = var.managed_by
  }
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.aws_app_server_instance_type
  depends_on    = [module.vpc, data.aws_ami.ubuntu]
  tags = {
    Environment = var.environment
    ManagedBy   = var.managed_by
    Name        = var.aws_app_server_name
  }
}
