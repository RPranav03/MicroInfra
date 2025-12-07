variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sku" {
  description = "SKU of the registry (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be Basic, Standard, or Premium."
  }
}

variable "admin_enabled" {
  description = "Specifies whether the admin user is enabled"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Enable encryption for the registry"
  type        = bool
  default     = false
}

variable "key_vault_key_id" {
  description = "The Key Vault Key ID for encryption"
  type        = string
  default     = null
}

variable "create_managed_identity" {
  description = "Create a managed identity for ACR"
  type        = bool
  default     = true
}

variable "webhook_name" {
  description = "Name of the webhook"
  type        = string
  default     = "webhook"
}

variable "webhook_service_uri" {
  description = "The service URI for the webhook"
  type        = string
  default     = ""
}

variable "webhook_events" {
  description = "The events for the webhook (push, delete, quarantine, chart_push, chart_delete)"
  type        = list(string)
  default     = ["push", "delete"]
}

variable "webhook_scope" {
  description = "The scope of the webhook"
  type        = string
  default     = ""
}

variable "webhook_status" {
  description = "Status of the webhook (enabled, disabled)"
  type        = string
  default     = "enabled"
}

variable "webhook_custom_headers" {
  description = "Custom headers for the webhook"
  type        = map(string)
  default     = {}
}

variable "webhooks" {
  description = "List of webhooks to create"
  type = list(object({
    name           = string
    service_uri    = string
    events         = list(string)
    scope          = optional(string)
    status         = optional(string, "enabled")
    custom_headers = optional(map(string), {})
  }))
  default = []
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default     = {}
}
