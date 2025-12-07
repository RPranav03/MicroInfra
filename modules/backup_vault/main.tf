resource "azurerm_recovery_services_vault" "main" {
  name                = var.backup_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.vault_sku
  soft_delete_enabled = true

  identity {
    type = "SystemAssigned"
  }
}

# Backup policy for VMs (simplified)
resource "azurerm_backup_policy_vm" "main" {
  count               = var.create_vm_backup_policy ? 1 : 0
  name                = "${var.backup_vault_name}-vm-policy"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.main.name

  backup {
    frequency = var.backup_frequency
    time      = var.backup_time
  }

  retention_daily {
    count = var.retention_daily_count
  }
}

# Azure Site Recovery replication policy (for DR)
resource "azurerm_site_recovery_replication_policy" "main" {
  count                                    = var.enable_site_recovery ? 1 : 0
  name                                     = "${var.backup_vault_name}-dr-policy"
  resource_group_name                      = var.resource_group_name
  recovery_vault_name                      = azurerm_recovery_services_vault.main.name
  recovery_point_retention_in_minutes      = var.recovery_point_retention_minutes
  application_consistent_snapshot_frequency_in_minutes = var.app_consistent_snapshot_frequency
}

