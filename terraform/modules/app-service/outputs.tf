output "backend_id" {
  description = "Backend App Service ID"
  value       = azurerm_linux_web_app.backend.id
}

output "backend_url" {
  description = "Backend App Service URL"
  value       = "https://${azurerm_linux_web_app.backend.default_hostname}"
}

output "frontend_id" {
  description = "Frontend App Service ID"
  value       = azurerm_linux_web_app.frontend.id
}

output "frontend_url" {
  description = "Frontend App Service URL"
  value       = "https://${azurerm_linux_web_app.frontend.default_hostname}"
}
