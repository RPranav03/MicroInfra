output "database_id" {
  description = "Database ID"
  value       = azurerm_mysql_database.main.id
}

output "database_name" {
  description = "Database name"
  value       = azurerm_mysql_database.main.name
}
