variable "app_insights_name" {
  description = "Name of Application Insights"
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

variable "application_type" {
  description = "Application type (web, other)"
  type        = string
  default     = "web"

  validation {
    condition     = contains(["web", "other"], var.application_type)
    error_message = "Application type must be 'web' or 'other'."
  }
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for integration"
  type        = string
}

variable "retention_in_days" {
  description = "Data retention in days"
  type        = number
  default     = 90

  validation {
    condition     = var.retention_in_days >= 30 && var.retention_in_days <= 730
    error_message = "Retention must be between 30 and 730 days."
  }
}

variable "sampling_percentage" {
  description = "Sampling percentage (0-100)"
  type        = number
  default     = 100

  validation {
    condition     = var.sampling_percentage >= 0 && var.sampling_percentage <= 100
    error_message = "Sampling percentage must be between 0 and 100."
  }
}

variable "daily_data_cap_in_gb" {
  description = "Daily data cap in GB (0 = unlimited)"
  type        = number
  default     = 0

  validation {
    condition     = var.daily_data_cap_in_gb >= 0
    error_message = "Daily data cap must be >= 0."
  }
}

variable "enable_alerts" {
  description = "Enable metric alerts"
  type        = bool
  default     = true
}

variable "action_group_id" {
  description = "Action Group ID for alerts"
  type        = string
  default     = ""
}

variable "response_time_threshold_ms" {
  description = "Response time threshold in milliseconds"
  type        = number
  default     = 2000
}

variable "exception_rate_threshold" {
  description = "Exception rate threshold"
  type        = number
  default     = 10
}

variable "enable_availability_test" {
  description = "Enable synthetic availability tests"
  type        = bool
  default     = true
}

variable "availability_test_url" {
  description = "URL for availability tests"
  type        = string
  default     = "https://example.com"
}

variable "availability_test_locations" {
  description = "Geographic locations for availability tests"
  type        = list(string)
  default     = ["us-il-ch1-azr", "us-tx-sn1-azr", "emea-nl-ams-azr"]
}

variable "tags" {
  description = "Tags for Application Insights"
  type        = map(string)
  default     = {}
}
