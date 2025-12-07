variable "storage_account_name" {
  description = "Name of the Storage Account"
  type        = string

  validation {
    condition     = length(var.storage_account_name) >= 3 && length(var.storage_account_name) <= 24
    error_message = "Storage Account name must be between 3 and 24 characters."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "account_tier" {
  description = "Storage Account tier (Standard or Premium)"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "Account tier must be 'Standard' or 'Premium'."
  }
}

variable "account_replication_type" {
  description = "Storage Account replication type (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS)"
  type        = string
  default     = "GRS"

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "Replication type must be one of: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "shared_access_key_enabled" {
  description = "Enable shared access key authentication"
  type        = bool
  default     = false
}

variable "network_default_action" {
  description = "Default network action (Allow/Deny)"
  type        = string
  default     = "Deny"

  validation {
    condition     = contains(["Allow", "Deny"], var.network_default_action)
    error_message = "Default action must be 'Allow' or 'Deny'."
  }
}

variable "network_bypass" {
  description = "List of services to bypass network restrictions"
  type        = list(string)
  default     = ["AzureServices"]
}

variable "allowed_subnet_ids" {
  description = "List of subnet IDs allowed to access storage"
  type        = list(string)
  default     = []
}

variable "allowed_ip_addresses" {
  description = "List of IP addresses allowed to access storage"
  type        = list(string)
  default     = []
}

variable "change_feed_retention_days" {
  description = "Retention period for change feed"
  type        = number
  default     = 30

  validation {
    condition     = var.change_feed_retention_days >= 1 && var.change_feed_retention_days <= 146000
    error_message = "Change feed retention must be between 1 and 146000 days."
  }
}

variable "create_blob_containers" {
  description = "Create default blob containers (app-data, backups, logs)"
  type        = bool
  default     = true
}

variable "enable_lifecycle_management" {
  description = "Enable automatic data lifecycle management"
  type        = bool
  default     = true
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for storage account"
  type        = bool
  default     = true
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags for the storage account"
  type        = map(string)
  default     = {}
}
