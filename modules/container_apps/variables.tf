variable "container_app_env_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "infrastructure_subnet_id" {
  type = string
}

variable "enable_internal_load_balancer" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
