output "id" {
  description = "Container Registry ID"
  value       = azurerm_container_registry.acr.id
}

output "login_server" {
  description = "Container Registry login server"
  value       = azurerm_container_registry.acr.login_server
}

output "admin_username" {
  description = "Container Registry admin username"
  value       = azurerm_container_registry.acr.admin_username
}

output "admin_password" {
  description = "Container Registry admin password"
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
}
