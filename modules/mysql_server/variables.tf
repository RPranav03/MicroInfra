variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "resource_group_name" {
  description = "Azure Resource Group name"
  type        = string
}

variable "administrator_login" {
  description = "Admin username"
  type        = string
  sensitive   = true
}

variable "administrator_login_password" {
  description = "Admin password"
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "SKU name"
  type        = string
  default     = "B_Gen5_1"
}

variable "storage_mb" {
  description = "Storage in MB"
  type        = number
  default     = 5120
}

variable "database_version" {
  description = "Database version"
  type        = string
  default     = "8.0"
}

variable "backup_retention_days" {
  description = "Backup retention days"
  type        = number
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  description = "Enable geo-redundant backup"
  type        = bool
  default     = true
}

variable "auto_grow_enabled" {
  description = "Enable auto grow"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = false
}

variable "ssl_enforcement_enabled" {
  description = "Enable SSL enforcement"
  type        = bool
  default     = true
}

variable "infra_encryption_enabled" {
  description = "Enable infrastructure encryption"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
