output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = try(azurerm_nat_gateway.main[0].id, null)
}

output "nat_gateway_public_ip" {
  description = "NAT Gateway Public IP address"
  value       = try(azurerm_public_ip.nat[0].ip_address, null)
}

output "public_ip_id" {
  description = "NAT Gateway Public IP ID"
  value       = try(azurerm_public_ip.nat[0].id, null)
}
