variable "private_endpoint_name" {
  description = "Name of the private endpoint"
  type        = string

  validation {
    condition     = length(var.private_endpoint_name) >= 1 && length(var.private_endpoint_name) <= 80
    error_message = "Private endpoint name must be between 1 and 80 characters."
  }
}

variable "location" {
  description = "Azure region for private endpoint"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the private endpoint will be placed"
  type        = string
}

variable "private_connection_resource_id" {
  description = "ID of the private link resource (e.g., ACR ID, Key Vault ID, MySQL ID)"
  type        = string
}

variable "subresource_names" {
  description = "Sub-resource names (e.g., ['registry'] for ACR, ['vault'] for Key Vault, ['mysqlServer'] for MySQL)"
  type        = list(string)

  validation {
    condition = alltrue([
      for name in var.subresource_names : contains(
        ["registry", "vault", "mysqlServer", "blob", "file", "queue", "table"],
        name
      )
    ])
    error_message = "Valid subresource names are: registry, vault, mysqlServer, blob, file, queue, table."
  }
}

variable "enable_private_dns_zone_group" {
  description = "Enable private DNS zone group for DNS integration"
  type        = bool
  default     = true
}

variable "private_dns_zone_ids" {
  description = "List of private DNS zone IDs for the private endpoint"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags for the private endpoint"
  type        = map(string)
  default = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

variable "depends_on_resources" {
  description = "Resources the private endpoint depends on (for explicit dependency management)"
  type        = list(any)
  default     = []
}
