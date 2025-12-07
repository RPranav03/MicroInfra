output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = azurerm_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = azurerm_subnet.private[*].id
}

output "public_subnet_names" {
  description = "Names of public subnets"
  value       = azurerm_subnet.public[*].name
}

output "private_subnet_names" {
  description = "Names of private subnets"
  value       = azurerm_subnet.private[*].name
}
