output "registry_id" {
  description = "The ID of the Azure Container Registry"
  value       = azurerm_container_registry.main.id
}

output "registry_name" {
  description = "The name of the Azure Container Registry"
  value       = azurerm_container_registry.main.name
}

output "login_server" {
  description = "The login server URL"
  value       = azurerm_container_registry.main.login_server
}

output "admin_username" {
  description = "Admin username for the registry"
  value       = azurerm_container_registry.main.admin_username
  sensitive   = true
}

output "admin_password" {
  description = "Admin password for the registry"
  value       = azurerm_container_registry.main.admin_password
  sensitive   = true
}

output "identity_principal_id" {
  description = "The Principal ID of the system-assigned managed identity"
  value       = azurerm_container_registry.main.identity[0].principal_id
}

output "managed_identity_id" {
  description = "The ID of the managed identity for ACR"
  value       = try(azurerm_user_assigned_identity.acr_identity[0].id, null)
}

output "webhook_ids" {
  description = "IDs of the created webhooks"
  value       = { for k, v in azurerm_container_registry_webhook.main : k => v.id }
}
