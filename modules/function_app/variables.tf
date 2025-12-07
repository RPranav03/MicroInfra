variable "app_service_plan_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "function_app_name" {
  type = string
}

variable "os_type" {
  type    = string
  default = "Windows"

  validation {
    condition     = contains(["Windows", "Linux"], var.os_type)
    error_message = "OS type must be 'Windows' or 'Linux'."
  }
}

variable "sku_name" {
  type    = string
  default = "Y1"
}

variable "storage_account_name" {
  type = string
}

variable "storage_account_access_key" {
  type      = string
  sensitive = true
}

variable "app_settings" {
  type    = map(string)
  default = {}
}

variable "app_insights_instrumentation_key" {
  type      = string
  sensitive = true
  default   = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
