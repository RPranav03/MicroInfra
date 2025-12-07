output "app_insights_id" {
  description = "ID of Application Insights"
  value       = azurerm_application_insights.main.id
}

output "app_insights_name" {
  description = "Name of Application Insights"
  value       = azurerm_application_insights.main.name
}

output "app_insights_instrumentation_key" {
  description = "Instrumentation key for SDK integration (sensitive)"
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}

output "app_insights_connection_string" {
  description = "Connection string for SDK integration (sensitive)"
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
}

output "app_insights_app_id" {
  description = "Application ID for queries"
  value       = azurerm_application_insights.main.app_id
  sensitive   = true
}

output "availability_test_id" {
  description = "ID of the availability test (if enabled)"
  value       = try(azurerm_application_insights_web_test.availability[0].id, "")
}
