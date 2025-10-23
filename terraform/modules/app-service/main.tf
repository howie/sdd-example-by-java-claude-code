resource "azurerm_service_plan" "main" {
  name                = "${var.project_name}-${var.environment}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P1v2"

  tags = var.tags
}

# Backend App Service
resource "azurerm_linux_web_app" "backend" {
  name                = "${var.project_name}-${var.environment}-backend"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      docker_image_name   = "backend:latest"
      docker_registry_url = "https://${var.acr_login_server}"
    }

    always_on = true

    cors {
      allowed_origins = [
        "https://${var.project_name}-${var.environment}-frontend.azurewebsites.net"
      ]
      support_credentials = true
    }
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${var.acr_login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = var.acr_admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = var.acr_admin_password
    "SPRING_PROFILES_ACTIVE"          = "prod"
    "DB_HOST"                         = var.db_host
    "DB_PORT"                         = "5432"
    "DB_NAME"                         = var.db_name
    "DB_USERNAME"                     = var.db_username
    "DB_PASSWORD"                     = var.db_password
    "SERVER_PORT"                     = "8080"
  }

  https_only = true

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Frontend App Service
resource "azurerm_linux_web_app" "frontend" {
  name                = "${var.project_name}-${var.environment}-frontend"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      docker_image_name   = "frontend:latest"
      docker_registry_url = "https://${var.acr_login_server}"
    }

    always_on = true
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${var.acr_login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = var.acr_admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = var.acr_admin_password
    "NEXT_PUBLIC_API_URL"             = "https://${azurerm_linux_web_app.backend.default_hostname}/api"
    "PORT"                            = "3000"
  }

  https_only = true

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
