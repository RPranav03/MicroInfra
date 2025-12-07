output "public_ip_ids" {
  description = "Public IP IDs"
  value       = azurerm_public_ip.main[*].id
}

output "public_ip_addresses" {
  description = "Public IP addresses"
  value       = azurerm_public_ip.main[*].ip_address
}
