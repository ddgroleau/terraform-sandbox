locals {
  sql_resource_name_prefix = "${var.environment}-tfsandbox-sql"
}

# SQL Server
resource "azurerm_mssql_server" "server" {
  name                         = "${local.sql_resource_name_prefix}-server"
  resource_group_name          = var.resource_group_name
  location                     = var.resource_group_location
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password # TODO: Convert to key vault reference
  version                      = "12.0"

  # Block public internet access
  public_network_access_enabled = false

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# SQL Database
resource "azurerm_mssql_database" "db" {
  name      = "${local.sql_resource_name_prefix}-db"
  server_id = azurerm_mssql_server.server.id
  sku_name  = "S0"

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Private Endpoint for SQL Server (Places network access within VNet)
resource "azurerm_private_endpoint" "sql" {
  name                = "${local.sql_resource_name_prefix}-pe"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_subnet_ids[1]

  private_service_connection {
    name                           = "${local.sql_resource_name_prefix}-psc"
    private_connection_resource_id = azurerm_mssql_server.server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Private DNS Zone so private IP can be resolved
resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Link Private Endpoint to DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  name                  = "${local.sql_resource_name_prefix}-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# A record to link SQL Server name to private IP
resource "azurerm_private_dns_a_record" "sql" {
  name                = azurerm_mssql_server.server.name
  zone_name           = azurerm_private_dns_zone.sql.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.sql.private_service_connection[0].private_ip_address]

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
