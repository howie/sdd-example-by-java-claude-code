output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "acr_login_server" {
  description = "Azure Container Registry login server"
  value       = module.container_registry.login_server
}

output "backend_app_url" {
  description = "Backend application URL"
  value       = module.app_service.backend_url
}

output "frontend_app_url" {
  description = "Frontend application URL"
  value       = module.app_service.frontend_url
}

output "database_fqdn" {
  description = "PostgreSQL server FQDN"
  value       = module.database.server_fqdn
}

output "database_name" {
  description = "PostgreSQL database name"
  value       = module.database.database_name
}
