variable "cluster_id" {
  description = "The ID of the Kubernetes cluster"
  type        = string
}

variable "node_pools" {
  description = "List of node pools to create"
  type = list(object({
    name               = string
    node_count         = optional(number, 1)
    vm_size            = optional(string, "Standard_D2s_v3")
    availability_zones = optional(list(number), [1, 2, 3])
    enable_auto_scaling = optional(bool, true)
    min_count          = optional(number, 1)
    max_count          = optional(number, 10)
    max_pods           = optional(number, 30)
    subnet_id          = string
    os_sku             = optional(string, "Ubuntu")
    priority           = optional(string, "Regular") # Regular or Spot
    eviction_policy    = optional(string, "Delete")   # Delete or Deallocate
    spot_max_price     = optional(number, -1)
    labels             = optional(map(string), {})
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
  }))
  default = []
}

variable "assign_managed_identity" {
  description = "Assign managed identity to node pools"
  type        = bool
  default     = false
}

variable "managed_identity_principal_id" {
  description = "Principal ID of the managed identity"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default     = {}
}
