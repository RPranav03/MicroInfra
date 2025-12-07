variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region for AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for AKS"
  type        = string
  default     = "1.27"
}

variable "node_pool_name" {
  description = "Name of the default node pool"
  type        = string
  default     = "systempool"
}

variable "node_count" {
  description = "Initial number of nodes in the default pool"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "Size of VM for nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "availability_zones" {
  description = "Availability zones for the node pool"
  type        = list(number)
  default     = [1, 2, 3]
}

variable "enable_auto_scaling" {
  description = "Enable auto-scaling for the node pool"
  type        = bool
  default     = true
}

variable "min_count" {
  description = "Minimum number of nodes"
  type        = number
  default     = 2
}

variable "max_count" {
  description = "Maximum number of nodes"
  type        = number
  default     = 10
}

variable "max_pods" {
  description = "Maximum number of pods per node"
  type        = number
  default     = 30
}

variable "subnet_id" {
  description = "ID of the subnet for AKS"
  type        = string
}

variable "client_id" {
  description = "Client ID for service principal"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Client secret for service principal"
  type        = string
  sensitive   = true
}

variable "rbac_enabled" {
  description = "Enable RBAC for AKS"
  type        = bool
  default     = true
}

variable "network_plugin" {
  description = "Network plugin for AKS (azure, kubenet)"
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "Network policy for AKS"
  type        = string
  default     = "azure"
}

variable "docker_bridge_cidr" {
  description = "Docker bridge CIDR"
  type        = string
  default     = "172.17.0.1/16"
}

variable "service_cidr" {
  description = "CIDR for Kubernetes services"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_service_ip" {
  description = "IP address for DNS service"
  type        = string
  default     = "10.0.0.10"
}

variable "load_balancer_sku" {
  description = "SKU for load balancer (standard, basic)"
  type        = string
  default     = "standard"
}

variable "enable_http_app_routing" {
  description = "Enable HTTP application routing"
  type        = bool
  default     = true
}

variable "enable_monitoring" {
  description = "Enable monitoring addon"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for monitoring"
  type        = string
  default     = null
}

variable "enable_azure_policy" {
  description = "Enable Azure Policy addon"
  type        = bool
  default     = true
}

variable "enable_kube_dashboard" {
  description = "Enable Kubernetes dashboard"
  type        = bool
  default     = true
}

variable "enable_acr" {
  description = "Enable Azure Container Registry"
  type        = bool
  default     = true
}

variable "acr_name" {
  description = "Name of Azure Container Registry"
  type        = string
}

variable "acr_sku" {
  description = "SKU of Azure Container Registry"
  type        = string
  default     = "Standard"
}

variable "acr_admin_enabled" {
  description = "Enable admin user for ACR"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default     = {}
}

variable "module_depends_on" {
  description = "Explicit module dependencies"
  type        = list(any)
  default     = []
}

