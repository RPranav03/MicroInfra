resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Webhook for automated builds/deployments
resource "azurerm_container_registry_webhook" "main" {
  for_each = { for idx, webhook in var.webhooks : idx => webhook }

  name                = each.value.name
  resource_group_name = var.resource_group_name
  registry_name       = azurerm_container_registry.main.name
  location            = var.location
  service_uri         = each.value.service_uri
  actions             = each.value.events
  scope               = each.value.scope
  custom_headers      = each.value.custom_headers
  status              = each.value.status
}

# Managed identity for RBAC
resource "azurerm_user_assigned_identity" "acr_identity" {
  count               = var.create_managed_identity ? 1 : 0
  name                = "${var.acr_name}-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}
