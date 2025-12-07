output "vnet_id" {
  description = "Virtual Network ID"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Virtual Network name"
  value       = azurerm_virtual_network.main.name
}

output "vnet_cidr" {
  description = "Virtual Network address space"
  value       = azurerm_virtual_network.main.address_space
}
