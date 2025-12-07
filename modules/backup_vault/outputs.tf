output "backup_vault_id" {
  description = "ID of the backup vault"
  value       = azurerm_recovery_services_vault.main.id
}

output "backup_vault_name" {
  description = "Name of the backup vault"
  value       = azurerm_recovery_services_vault.main.name
}

output "vm_backup_policy_id" {
  description = "ID of the VM backup policy (if created)"
  value       = try(azurerm_backup_policy_vm.main[0].id, "")
}

output "database_backup_policy_id" {
  description = "ID of the database backup policy (if created)"
  value       = ""
}

output "site_recovery_policy_id" {
  description = "ID of the site recovery policy (if created)"
  value       = try(azurerm_site_recovery_replication_policy.main[0].id, "")
}
