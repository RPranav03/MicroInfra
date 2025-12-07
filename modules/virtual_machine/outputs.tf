output "vm_ids" {
  description = "VM IDs"
  value       = azurerm_virtual_machine.main[*].id
}

output "vm_names" {
  description = "VM names"
  value       = azurerm_virtual_machine.main[*].name
}
