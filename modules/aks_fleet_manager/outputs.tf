output "fleet_manager_id" {
  value = "managed-via-cli"
  description = "AKS Fleet Manager is managed via Azure CLI or Portal"
}

output "fleet_manager_name" {
  value = var.fleet_manager_name
}
