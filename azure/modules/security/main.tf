# Private Network Security Group
resource "azurerm_network_security_group" "sg_private" {
  name                = "${var.security_group_name}-private"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# K8s GatewayManager must be able to reach App Gateway backends on ports 65200-65535 for health probes.
resource "azurerm_network_security_rule" "private_allow_gateway_manager" {
  name                        = "Allow-GatewayManager"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "65200-65535"
  source_address_prefix       = "GatewayManager"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.sg_private.name
}

# Private NSG Rules
resource "azurerm_network_security_rule" "private_allow_from_public" {
  name                        = "Allow-From-Public-Subnet"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefixes     = ["10.0.1.0/24", "10.0.2.0/24"]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.sg_private.name
}

resource "azurerm_network_security_rule" "private_allow_pod_to_pod" {
  name                        = "Allow-Pod-to-Pod"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/16"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.sg_private.name
}

resource "azurerm_network_security_rule" "private_deny_all" {
  name                        = "Deny-All-Inbound"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.sg_private.name
}

resource "azurerm_network_security_rule" "private_allow_outbound" {
  name                        = "Allow-All-Outbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.sg_private.name
}
