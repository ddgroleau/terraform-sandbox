output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "app_gateway_subnet_id" {
  value = azurerm_subnet.app_gateway.id
}

output "private_subnet_ids" {
  value = azurerm_subnet.private[*].id
}

output "app_gateway_id" {
  value = azurerm_application_gateway.network.id
}

output "backend_address_pool_id" {
  value = tolist(azurerm_application_gateway.network.backend_address_pool)[0].id
}
