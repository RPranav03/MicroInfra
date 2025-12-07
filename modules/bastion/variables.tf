variable "bastion_name" {
  description = "Name of Azure Bastion"
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

variable "bastion_subnet_id" {
  description = "Subnet ID for Bastion (must be named AzureBastionSubnet)"
  type        = string
}

variable "bastion_sku" {
  description = "Bastion SKU (Basic or Standard)"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard"], var.bastion_sku)
    error_message = "Bastion SKU must be 'Basic' or 'Standard'."
  }
}

variable "availability_zones" {
  description = "Availability zones for Bastion public IP"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "enable_tunneling" {
  description = "Enable tunneling through Bastion"
  type        = bool
  default     = true
}

variable "enable_shareable_link" {
  description = "Enable shareable links"
  type        = bool
  default     = true
}

variable "enable_copy_paste" {
  description = "Enable copy-paste functionality"
  type        = bool
  default     = true
}

variable "enable_file_copy" {
  description = "Enable file copy functionality"
  type        = bool
  default     = true
}

variable "enable_ip_connect" {
  description = "Enable IP-based connection"
  type        = bool
  default     = true
}

variable "enable_kerberos" {
  description = "Enable Kerberos authentication"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for diagnostics"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags for Bastion"
  type        = map(string)
  default     = {}
}
