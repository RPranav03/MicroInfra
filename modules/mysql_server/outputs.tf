output "mysql_server_id" {
  description = "MySQL Server ID"
  value       = azurerm_mysql_server.main.id
}

output "mysql_server_fqdn" {
  description = "MySQL Server FQDN"
  value       = azurerm_mysql_server.main.fqdn
}

output "mysql_server_name" {
  description = "MySQL Server name"
  value       = azurerm_mysql_server.main.name
}
