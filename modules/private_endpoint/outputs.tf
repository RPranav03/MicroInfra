output "private_endpoint_id" {
  description = "ID of the private endpoint"
  value       = azurerm_private_endpoint.main.id
}

output "private_endpoint_name" {
  description = "Name of the private endpoint"
  value       = azurerm_private_endpoint.main.name
}

output "private_ip_address" {
  description = "Private IP address assigned to the private endpoint"
  value       = azurerm_private_endpoint.main.private_service_connection[0].private_ip_address
}

output "network_interface_id" {
  description = "ID of the network interface for the private endpoint"
  value       = try(azurerm_private_endpoint.main.network_interface[0].id, "")
}

output "private_dns_zone_group_id" {
  description = "ID of the private DNS zone group (if enabled)"
  value       = try(azurerm_private_endpoint.main.private_dns_zone_group[0].id, "")
}
