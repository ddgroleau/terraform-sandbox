# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# App Gateway Dedicated Subnet
resource "azurerm_subnet" "app_gateway" {
  name                 = "${var.environment}-appgw-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Private Subnets
resource "azurerm_subnet" "private" {
  count                = 2
  name                 = "${var.environment}-private-az${count.index + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.${count.index + 2}.0/24"] # 10.0.2.0/24, 10.0.3.0/24
}

# Associate NSGs to Private Subnets
resource "azurerm_subnet_network_security_group_association" "private" {
  count                     = 2
  subnet_id                 = azurerm_subnet.private[count.index].id
  network_security_group_id = var.private_security_group_id
}

# Public IP for NAT Gateway
resource "azurerm_public_ip" "nat" {
  name                = "${var.environment}-nat-pip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# NAT Gateway
resource "azurerm_nat_gateway" "nat" {
  name                = "${var.environment}-nat-gateway"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
}

# Associate Public IP to NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "nat" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat.id
}

# Associate NAT Gateway to private subnets (for outbound)
resource "azurerm_subnet_nat_gateway_association" "private" {
  count          = 2
  subnet_id      = azurerm_subnet.private[count.index].id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}

# Public IP for App Gateway
resource "azurerm_public_ip" "app_gateway" {
  name                = "${var.environment}-app-gateway-pip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Set local variables for App Gateway configuration
locals {
  backend_address_pool_name       = "${azurerm_virtual_network.vnet.name}-beap"
  http_port_name                  = "${azurerm_virtual_network.vnet.name}-httpport"
  https_port_name                 = "${azurerm_virtual_network.vnet.name}-httpsport"
  frontend_ip_configuration_name  = "${azurerm_virtual_network.vnet.name}-feip"
  http_setting_name               = "${azurerm_virtual_network.vnet.name}-be-htst"
  http_listener_name              = "${azurerm_virtual_network.vnet.name}-httplstn"
  https_listener_name             = "${azurerm_virtual_network.vnet.name}-httpslstn"
  request_routing_rule_name_http  = "${azurerm_virtual_network.vnet.name}-httprqrt"
  request_routing_rule_name_https = "${azurerm_virtual_network.vnet.name}-httpsrqrt"
  redirect_configuration_name     = "${azurerm_virtual_network.vnet.name}-rdrcfg"
}

# App Gateway
resource "azurerm_application_gateway" "network" {
  name                = "${var.environment}-app-gateway"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "${var.environment}-gateway-ip-configuration"
    subnet_id = azurerm_subnet.app_gateway.id
  }

  # HTTP on Port 80
  frontend_port {
    name = local.http_port_name
    port = 80
  }

  # HTTPS on Port 443
  frontend_port {
    name = local.https_port_name
    port = 443
  }

  # SSL Certificate (using self-signed for demo - use Key Vault for production)
  ssl_certificate {
    name     = "${var.environment}-ssl-cert"
    data     = filebase64("${path.module}/cert.pfx") # Or use Key Vault secret_id
    password = var.ssl_cert_password
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.app_gateway.id
  }

  # HTTP Port 80 Listener
  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.http_port_name
    protocol                       = "Http"
  }

  # HTTPS Port 443 Listener
  http_listener {
    name                           = local.https_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.https_port_name
    protocol                       = "Https"
    ssl_certificate_name           = "${var.environment}-ssl-cert"
  }

  redirect_configuration {
    name                 = local.redirect_configuration_name
    redirect_type        = "Permanent"
    target_listener_name = local.https_listener_name
    include_path         = true
    include_query_string = true
  }

  # Redirect HTTP to HTTPS using the redirect configuration
  request_routing_rule {
    name                        = local.request_routing_rule_name_http
    priority                    = 9
    rule_type                   = "Basic"
    http_listener_name          = local.http_listener_name
    redirect_configuration_name = local.redirect_configuration_name
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name_https
    priority                   = 10
    rule_type                  = "Basic"
    http_listener_name         = local.https_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  # TLS Termination at App Gateway
  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }
}
