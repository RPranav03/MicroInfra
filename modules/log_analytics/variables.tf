variable "workspace_name" {
  description = "Name of the Log Analytics Workspace"
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

variable "sku" {
  description = "SKU of the Log Analytics Workspace (Free, PerGB2018, CapacityReservation)"
  type        = string
  default     = "PerGB2018"

  validation {
    condition     = contains(["Free", "PerGB2018", "CapacityReservation"], var.sku)
    error_message = "SKU must be Free, PerGB2018, or CapacityReservation."
  }
}

variable "retention_in_days" {
  description = "Retention period in days (7 to 730)"
  type        = number
  default     = 30

  validation {
    condition     = var.retention_in_days >= 7 && var.retention_in_days <= 730
    error_message = "Retention must be between 7 and 730 days."
  }
}

variable "enable_aks_monitoring" {
  description = "Enable AKS monitoring solution (Container Insights)"
  type        = bool
  default     = true
}

variable "enable_aks_diagnostics" {
  description = "Enable AKS diagnostic logs"
  type        = bool
  default     = true
}

variable "enable_alerts" {
  description = "Enable monitor metric alerts"
  type        = bool
  default     = true
}

variable "aks_cluster_id" {
  description = "ID of the AKS cluster for diagnostics and alerts"
  type        = string
  default     = null
}

variable "action_group_id" {
  description = "ID of the action group for alerts"
  type        = string
  default     = null
}

variable "cpu_threshold_percentage" {
  description = "CPU usage threshold for alerts (%)"
  type        = number
  default     = 80
}

variable "memory_threshold_percentage" {
  description = "Memory usage threshold for alerts (%)"
  type        = number
  default     = 85
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default     = {}
}
