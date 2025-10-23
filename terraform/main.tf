terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    # Backend configuration should be provided via backend config file or CLI
    # resource_group_name  = "tfstate-rg"
    # storage_account_name = "tfstate"
    # container_name       = "tfstate"
    # key                  = "demo-app.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location

  tags = var.tags
}

# Container Registry
module "container_registry" {
  source = "./modules/container-registry"

  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  project_name       = var.project_name
  environment        = var.environment
  tags              = var.tags
}

# Networking
module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  project_name       = var.project_name
  environment        = var.environment
  tags              = var.tags
}

# Database
module "database" {
  source = "./modules/database"

  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  project_name       = var.project_name
  environment        = var.environment
  subnet_id          = module.networking.database_subnet_id
  db_admin_password  = var.db_admin_password
  tags              = var.tags
}

# App Service
module "app_service" {
  source = "./modules/app-service"

  resource_group_name     = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  project_name           = var.project_name
  environment            = var.environment
  subnet_id              = module.networking.app_subnet_id
  acr_login_server       = module.container_registry.login_server
  acr_admin_username     = module.container_registry.admin_username
  acr_admin_password     = module.container_registry.admin_password
  db_host                = module.database.server_fqdn
  db_name                = module.database.database_name
  db_username            = module.database.admin_username
  db_password            = var.db_admin_password
  tags                  = var.tags
}
