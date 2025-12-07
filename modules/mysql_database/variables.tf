variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "server_name" {
  description = "MySQL Server name"
  type        = string
}

variable "database_name" {
  description = "Database name"
  type        = string
}

variable "charset" {
  description = "Character set"
  type        = string
  default     = "utf8"
}

variable "collation" {
  description = "Collation"
  type        = string
  default     = "utf8_unicode_ci"
}
