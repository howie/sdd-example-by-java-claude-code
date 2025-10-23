output "vnet_id" {
  description = "Virtual Network ID"
  value       = azurerm_virtual_network.vnet.id
}

output "app_subnet_id" {
  description = "App Service subnet ID"
  value       = azurerm_subnet.app_subnet.id
}

output "database_subnet_id" {
  description = "Database subnet ID"
  value       = azurerm_subnet.database_subnet.id
}
