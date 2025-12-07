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

variable "ip_count" {
  description = "Number of public IPs"
  type        = number
  default     = 1
}

variable "allocation_method" {
  description = "Public IP allocation method"
  type        = string
  default     = "Static"
}

variable "sku" {
  description = "Public IP SKU"
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
