resource "azurerm_container_app_environment" "main" {
  name                           = var.container_app_env_name
  location                       = var.location
  resource_group_name            = var.resource_group_name
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  infrastructure_subnet_id       = var.infrastructure_subnet_id
  internal_load_balancer_enabled = var.enable_internal_load_balancer

  tags = var.tags
}

# Container Apps are deployed separately (not managed in this module)
# This module provides the infrastructure/environment only
