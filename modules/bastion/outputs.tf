output "bastion_id" {
  description = "ID of Azure Bastion"
  value       = azurerm_bastion_host.main.id
}

output "bastion_name" {
  description = "Name of Azure Bastion"
  value       = azurerm_bastion_host.main.name
}

output "bastion_public_ip" {
  description = "Public IP address of Bastion"
  value       = azurerm_public_ip.bastion.ip_address
}

output "public_ip_id" {
  description = "ID of Bastion public IP"
  value       = azurerm_public_ip.bastion.id
}
