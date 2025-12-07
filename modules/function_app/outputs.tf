output "function_app_id" {
  value = try(azurerm_windows_function_app.main[0].id, azurerm_linux_function_app.main[0].id)
}

output "function_app_name" {
  value = try(azurerm_windows_function_app.main[0].name, azurerm_linux_function_app.main[0].name)
}

output "function_app_default_hostname" {
  value = try(azurerm_windows_function_app.main[0].default_hostname, azurerm_linux_function_app.main[0].default_hostname)
}

output "app_service_plan_id" {
  value = azurerm_service_plan.main.id
}
