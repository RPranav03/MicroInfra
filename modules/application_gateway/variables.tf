variable "app_gateway_name" {
  description = "Name of the Application Gateway"
  type        = string

  validation {
    condition     = length(var.app_gateway_name) >= 1 && length(var.app_gateway_name) <= 80
    error_message = "Application Gateway name must be between 1 and 80 characters."
  }
}

variable "location" {
  description = "Azure region for Application Gateway"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "app_gateway_subnet_id" {
  description = "Subnet ID where Application Gateway will be deployed"
  type        = string
}

variable "sku_name" {
  description = "SKU name of the Application Gateway"
  type        = string
  default     = "Standard_v2"

  validation {
    condition     = contains(["Standard_v2", "WAF_v2"], var.sku_name)
    error_message = "SKU name must be 'Standard_v2' or 'WAF_v2'."
  }
}

variable "sku_tier" {
  description = "SKU tier of the Application Gateway"
  type        = string
  default     = "Standard_v2"

  validation {
    condition     = contains(["Standard_v2", "WAF_v2"], var.sku_tier)
    error_message = "SKU tier must be 'Standard_v2' or 'WAF_v2'."
  }
}

variable "capacity" {
  description = "Number of Application Gateway instances"
  type        = number
  default     = 2

  validation {
    condition     = var.capacity >= 1 && var.capacity <= 32
    error_message = "Capacity must be between 1 and 32."
  }
}

variable "availability_zones" {
  description = "Availability zones for Application Gateway"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "enable_waf" {
  description = "Enable Web Application Firewall"
  type        = bool
  default     = true
}

variable "waf_mode" {
  description = "WAF mode - Detection or Prevention"
  type        = string
  default     = "Prevention"

  validation {
    condition     = contains(["Detection", "Prevention"], var.waf_mode)
    error_message = "WAF mode must be 'Detection' or 'Prevention'."
  }
}

variable "aks_resource_group_id" {
  description = "Resource group ID of AKS cluster (for AGIC RBAC)"
  type        = string
}

variable "tags" {
  description = "Tags for Application Gateway"
  type        = map(string)
  default = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}
