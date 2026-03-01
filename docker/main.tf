terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6.2"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_network" "tutorial" {
  name   = var.container_name
  driver = "bridge"
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = var.container_name
  networks_advanced {
    name = docker_network.tutorial.name
  }
  ports {
    internal = 80
    external = var.external_nginx_port
  }
}
