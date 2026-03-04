resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}-rg"
  location = var.resource_group_location

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
