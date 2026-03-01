output "aws_ami_ubuntu_id" {
  description = "The ID of the Ubuntu AMI"
  value       = data.aws_ami.ubuntu.id
}

output "aws_instance_app_server_id" {
  description = "The ID of the app server instance"
  value       = aws_instance.app_server.id
}

output "aws_instance_app_server_public_ip" {
  description = "The public IP address of the app server instance"
  value       = aws_instance.app_server.public_ip
}

output "aws_instance_app_server_availability_zone" {
  description = "The availability zone of the app server instance"
  value       = aws_instance.app_server.availability_zone
}

output "aws_instance_app_server_private_dns" {
  description = "Private DNS name of the EC2 instance."
  value       = aws_instance.app_server.private_dns
}

