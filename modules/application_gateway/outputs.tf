output "app_gateway_id" {
  description = "ID of the Application Gateway"
  value       = azurerm_application_gateway.main.id
}

output "app_gateway_name" {
  description = "Name of the Application Gateway"
  value       = azurerm_application_gateway.main.name
}

output "app_gateway_public_ip" {
  description = "Public IP address of the Application Gateway"
  value       = azurerm_public_ip.appgw.ip_address
}

output "app_gateway_backend_pool_id" {
  description = "Backend address pool ID for AKS ingress"
  value       = "${azurerm_application_gateway.main.id}/backendAddressPools/${var.app_gateway_name}-backend-pool"
}

output "agic_managed_identity_id" {
  description = "Managed Identity ID for Application Gateway Ingress Controller"
  value       = azurerm_user_assigned_identity.agic.id
}

output "agic_managed_identity_principal_id" {
  description = "Principal ID of AGIC Managed Identity"
  value       = azurerm_user_assigned_identity.agic.principal_id
}

output "agic_managed_identity_client_id" {
  description = "Client ID of AGIC Managed Identity"
  value       = azurerm_user_assigned_identity.agic.client_id
}
