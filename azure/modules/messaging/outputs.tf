output "servicebus_topic_id" {
  value = azurerm_servicebus_topic.default.id
}

output "servicebus_namespace_id" {
  value = azurerm_servicebus_namespace.default.id
}

output "servicebus_connection_string" {
  value     = azurerm_servicebus_namespace_authorization_rule.app.primary_connection_string
  sensitive = true
}
