locals {
  messaging_resource_name_prefix = "${var.environment}-tfsandbox-servicebus"
}

# Service Bus Namespace
resource "azurerm_servicebus_namespace" "default" {
  name                = "${local.messaging_resource_name_prefix}-namespace"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Service Bus Topic
resource "azurerm_servicebus_topic" "default" {
  name                 = "${local.messaging_resource_name_prefix}-topic"
  namespace_id         = azurerm_servicebus_namespace.default.id
  partitioning_enabled = true
  default_message_ttl  = "P7D"
}

# Service Bus Subscription
resource "azurerm_servicebus_subscription" "default" {
  name                                 = "${local.messaging_resource_name_prefix}-subscription"
  topic_id                             = azurerm_servicebus_topic.default.id
  max_delivery_count                   = 10
  dead_lettering_on_message_expiration = true
}

# Authorization Rule for connection string
resource "azurerm_servicebus_namespace_authorization_rule" "app" {
  name         = "${local.messaging_resource_name_prefix}-app-policy"
  namespace_id = azurerm_servicebus_namespace.default.id
  send         = true
  listen       = true
  manage       = false
}
