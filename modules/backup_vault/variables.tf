variable "backup_vault_name" {
  description = "Name of the backup vault"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vault_sku" {
  description = "SKU for recovery services vault"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "RS0"], var.vault_sku)
    error_message = "Vault SKU must be 'Standard' or 'RS0'."
  }
}

variable "immutability_enabled" {
  description = "Enable immutability for backup data"
  type        = bool
  default     = true
}

variable "create_vm_backup_policy" {
  description = "Create backup policy for VMs"
  type        = bool
  default     = true
}

variable "backup_frequency" {
  description = "VM backup frequency (Daily)"
  type        = string
  default     = "Daily"
}

variable "backup_time" {
  description = "VM backup time in 24-hour format (HH:mm)"
  type        = string
  default     = "23:00"
}

variable "retention_daily_count" {
  description = "Daily backup retention count"
  type        = number
  default     = 7

  validation {
    condition     = var.retention_daily_count >= 1 && var.retention_daily_count <= 9999
    error_message = "Retention daily count must be between 1 and 9999."
  }
}

variable "retention_weekly_count" {
  description = "Weekly backup retention count"
  type        = number
  default     = 4

  validation {
    condition     = var.retention_weekly_count >= 1 && var.retention_weekly_count <= 5163
    error_message = "Retention weekly count must be between 1 and 5163."
  }
}

variable "retention_weekly_days" {
  description = "Days for weekly backup retention"
  type        = list(string)
  default     = ["Monday"]
}

variable "retention_monthly_count" {
  description = "Monthly backup retention count"
  type        = number
  default     = 12

  validation {
    condition     = var.retention_monthly_count >= 1 && var.retention_monthly_count <= 1188
    error_message = "Retention monthly count must be between 1 and 1188."
  }
}

variable "retention_yearly_count" {
  description = "Yearly backup retention count"
  type        = number
  default     = 1

  validation {
    condition     = var.retention_yearly_count >= 1 && var.retention_yearly_count <= 99
    error_message = "Retention yearly count must be between 1 and 99."
  }
}

variable "create_database_backup_policy" {
  description = "Create backup policy for databases"
  type        = bool
  default     = true
}

variable "db_backup_frequency" {
  description = "Database backup frequency (Daily)"
  type        = string
  default     = "Daily"
}

variable "db_backup_time" {
  description = "Database backup time in 24-hour format (HH:mm)"
  type        = string
  default     = "22:00"
}

variable "db_backup_zone_redundancy" {
  description = "Enable zone redundancy for database backups"
  type        = bool
  default     = true
}

variable "db_retention_daily_count" {
  description = "Daily database backup retention count"
  type        = number
  default     = 7
}

variable "db_retention_weekly_count" {
  description = "Weekly database backup retention count"
  type        = number
  default     = 4
}

variable "db_retention_weekly_days" {
  description = "Days for weekly database backup retention"
  type        = list(string)
  default     = ["Monday"]
}

variable "db_retention_monthly_count" {
  description = "Monthly database backup retention count"
  type        = number
  default     = 12
}

variable "enable_site_recovery" {
  description = "Enable site recovery / disaster recovery"
  type        = bool
  default     = false
}

variable "recovery_point_retention_minutes" {
  description = "Recovery point retention in minutes"
  type        = number
  default     = 1440  # 24 hours
}

variable "app_consistent_snapshot_frequency" {
  description = "Application consistent snapshot frequency in minutes"
  type        = number
  default     = 60
}

variable "tags" {
  description = "Tags for the backup vault"
  type        = map(string)
  default     = {}
}
