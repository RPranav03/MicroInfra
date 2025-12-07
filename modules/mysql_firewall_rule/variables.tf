variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "server_name" {
  description = "MySQL Server name"
  type        = string
}

variable "firewall_rules" {
  description = "Firewall rules"
  type = list(object({
    name              = string
    start_ip_address  = string
    end_ip_address    = string
  }))
  default = []
}
