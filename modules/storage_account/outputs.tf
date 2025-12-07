output "storage_account_id" {
  description = "ID of the Storage Account"
  value       = azurerm_storage_account.main.id
}

output "storage_account_name" {
  description = "Name of the Storage Account"
  value       = azurerm_storage_account.main.name
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

output "primary_access_key" {
  description = "Primary access key (sensitive)"
  value       = azurerm_storage_account.main.primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "Secondary access key (sensitive)"
  value       = azurerm_storage_account.main.secondary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "Primary connection string (sensitive)"
  value       = azurerm_storage_account.main.primary_connection_string
  sensitive   = true
}

output "blob_container_ids" {
  description = "IDs of created blob containers"
  value = {
    app_data = try(azurerm_storage_container.app_data[0].id, "")
    backups  = try(azurerm_storage_container.backups[0].id, "")
    logs     = try(azurerm_storage_container.logs[0].id, "")
  }
}

output "private_endpoint_id" {
  description = "ID of the blob private endpoint (if enabled)"
  value       = try(azurerm_private_endpoint.blob[0].id, "")
}
