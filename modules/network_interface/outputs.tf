output "nic_ids" {
  description = "Network Interface IDs"
  value       = azurerm_network_interface.main[*].id
}

output "nic_names" {
  description = "Network Interface names"
  value       = azurerm_network_interface.main[*].name
}

output "private_ips" {
  description = "Private IP addresses"
  value       = azurerm_network_interface.main[*].private_ip_address
}
