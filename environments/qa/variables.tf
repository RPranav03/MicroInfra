variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "client_id" {
  description = "Azure Service Principal Client ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Azure Service Principal Client Secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  sensitive   = true
}

variable "location" {
  description = "Azure location/region"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Azure Resource Group name"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, qa, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "qa", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, qa, staging, prod"
  }
}

variable "vnet_cidr" {
  description = "CIDR block for Virtual Network"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = true
}

variable "enable_bastion" {
  description = "Enable Bastion Host for secure access"
  type        = bool
  default     = false
}

variable "enable_service_endpoints" {
  description = "Enable service endpoints for Storage and SQL"
  type        = bool
  default     = true
}

variable "app_nsg_rules" {
  description = "NSG rules for application tier"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = [
    {
      name                       = "AllowHTTP"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowHTTPS"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowAppPort"
      priority                   = 102
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "10.0.0.0/16"
      destination_address_prefix = "*"
    }
  ]
}

variable "database_nsg_rules" {
  description = "NSG rules for database tier"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = [
    {
      name                       = "AllowMySQL"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3306"
      source_address_prefix      = "10.0.0.0/16"
      destination_address_prefix = "*"
    }
  ]
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B2s"
}

variable "vm_image_publisher" {
  description = "VM image publisher"
  type        = string
  default     = "Canonical"
}

variable "vm_image_offer" {
  description = "VM image offer"
  type        = string
  default     = "0001-com-ubuntu-server-focal"
}

variable "vm_image_sku" {
  description = "VM image SKU"
  type        = string
  default     = "20_04-lts-gen2"
}

variable "vm_image_version" {
  description = "VM image version"
  type        = string
  default     = "Latest"
}

variable "vm_count" {
  description = "Number of VM instances"
  type        = number
  default     = 1
}

variable "vm_admin_username" {
  description = "VM admin username"
  type        = string
  default     = "azureuser"
  sensitive   = true
}

variable "vm_disable_password_authentication" {
  description = "Disable password authentication"
  type        = bool
  default     = true
}

variable "user_data" {
  description = "User data script for VMs"
  type        = string
  default     = ""
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "db_administrator_login" {
  description = "Database administrator login"
  type        = string
  default     = "sqladmin"
  sensitive   = true
}

variable "db_administrator_login_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "db_sku_name" {
  description = "Database SKU name (e.g., B_Gen5_1, GP_Gen5_2)"
  type        = string
  default     = "B_Gen5_1"
}

variable "db_storage_mb" {
  description = "Database storage in MB"
  type        = number
  default     = 5120
}

variable "db_version" {
  description = "Database version"
  type        = string
  default     = "8.0"
}

variable "db_backup_retention_days" {
  description = "Database backup retention period"
  type        = number
  default     = 7
}

variable "db_geo_redundant_backup" {
  description = "Enable geo-redundant backup"
  type        = bool
  default     = true
}

variable "db_auto_grow_enabled" {
  description = "Enable automatic storage growth"
  type        = bool
  default     = true
}

variable "db_infrastructure_encryption" {
  description = "Enable infrastructure encryption"
  type        = bool
  default     = true
}

variable "db_firewall_rules" {
  description = "MySQL firewall rules"
  type = list(object({
    name              = string
    start_ip_address  = string
    end_ip_address    = string
  }))
  default = [
    {
      name              = "AllowAllAzureServices"
      start_ip_address  = "0.0.0.0"
      end_ip_address    = "0.0.0.0"
    }
  ]
}

variable "kubernetes_version" {
  description = "Kubernetes version for AKS"
  type        = string
  default     = "1.27"
}

variable "sp_client_id" {
  description = "Service Principal Client ID for AKS"
  type        = string
  sensitive   = true
}

variable "sp_client_secret" {
  description = "Service Principal Client Secret for AKS"
  type        = string
  sensitive   = true
}

variable "aks_node_count" {
  description = "Initial number of nodes in AKS default pool"
  type        = number
  default     = 2
}

variable "aks_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "aks_availability_zones" {
  description = "Availability zones for AKS nodes"
  type        = list(number)
  default     = [1, 2, 3]
}

variable "aks_enable_auto_scaling" {
  description = "Enable auto-scaling for AKS"
  type        = bool
  default     = true
}

variable "aks_min_count" {
  description = "Minimum number of nodes in AKS"
  type        = number
  default     = 2
}

variable "aks_max_count" {
  description = "Maximum number of nodes in AKS"
  type        = number
  default     = 10
}

variable "aks_max_pods" {
  description = "Maximum pods per node in AKS"
  type        = number
  default     = 30
}

variable "aks_docker_bridge_cidr" {
  description = "Docker bridge CIDR for AKS"
  type        = string
  default     = "172.17.0.1/16"
}

variable "aks_service_cidr" {
  description = "CIDR for Kubernetes services"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aks_dns_service_ip" {
  description = "DNS service IP for AKS"
  type        = string
  default     = "10.0.0.10"
}

variable "aks_additional_node_pools" {
  description = "Additional node pools for AKS"
  type = list(object({
    name                = string
    node_count          = optional(number, 1)
    vm_size             = optional(string, "Standard_D2s_v3")
    availability_zones  = optional(list(number), [1, 2, 3])
    enable_auto_scaling = optional(bool, true)
    min_count           = optional(number, 1)
    max_count           = optional(number, 10)
    max_pods            = optional(number, 30)
    subnet_id           = string
    os_sku              = optional(string, "Ubuntu")
    priority            = optional(string, "Regular")
    eviction_policy     = optional(string, "Delete")
    spot_max_price      = optional(number, -1)
    labels              = optional(map(string), {})
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
  }))
  default = []
}

variable "acr_sku" {
  description = "SKU for Azure Container Registry"
  type        = string
  default     = "Standard"
  
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "ACR SKU must be Basic, Standard, or Premium"
  }
}

variable "acr_enable_encryption" {
  description = "Enable encryption for ACR"
  type        = bool
  default     = false
}

variable "acr_webhooks" {
  description = "Container Registry webhooks for CI/CD"
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

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

variable "log_analytics_sku" {
  description = "SKU for Log Analytics Workspace"
  type        = string
  default     = "PerGB2018"

  validation {
    condition     = contains(["Free", "PerGB2018", "Premium", "Standard", "Standalone", "CapacityReservation"], var.log_analytics_sku)
    error_message = "Log Analytics SKU must be one of: Free, PerGB2018, Premium, Standard, Standalone, CapacityReservation"
  }
}

variable "log_analytics_retention_days" {
  description = "Data retention period in days for Log Analytics"
  type        = number
  default     = 30

  validation {
    condition     = var.log_analytics_retention_days >= 7 && var.log_analytics_retention_days <= 730
    error_message = "Log Analytics retention days must be between 7 and 730"
  }
}

variable "log_analytics_enable_aks_monitoring" {
  description = "Enable Container Insights solution for AKS monitoring"
  type        = bool
  default     = true
}

variable "log_analytics_enable_aks_diagnostics" {
  description = "Enable diagnostic logs from AKS cluster"
  type        = bool
  default     = true
}

variable "log_analytics_enable_alerts" {
  description = "Enable metric alerts for AKS cluster (CPU, memory)"
  type        = bool
  default     = true
}

variable "log_analytics_cpu_threshold" {
  description = "CPU threshold percentage for alerts"
  type        = number
  default     = 80

  validation {
    condition     = var.log_analytics_cpu_threshold >= 0 && var.log_analytics_cpu_threshold <= 100
    error_message = "CPU threshold must be between 0 and 100"
  }
}

variable "log_analytics_memory_threshold" {
  description = "Memory threshold percentage for alerts"
  type        = number
  default     = 85

  validation {
    condition     = var.log_analytics_memory_threshold >= 0 && var.log_analytics_memory_threshold <= 100
    error_message = "Memory threshold must be between 0 and 100"
  }
}

variable "key_vault_sku_name" {
  description = "SKU for Azure Key Vault"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.key_vault_sku_name)
    error_message = "Key Vault SKU must be 'standard' or 'premium'"
  }
}

variable "key_vault_purge_protection_enabled" {
  description = "Enable purge protection on Key Vault"
  type        = bool
  default     = true
}

variable "key_vault_soft_delete_retention_days" {
  description = "Soft delete retention days for Key Vault"
  type        = number
  default     = 30

  validation {
    condition     = var.key_vault_soft_delete_retention_days >= 7 && var.key_vault_soft_delete_retention_days <= 90
    error_message = "Soft delete retention must be between 7 and 90 days"
  }
}

variable "key_vault_network_default_action" {
  description = "Default network action for Key Vault (Allow/Deny)"
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.key_vault_network_default_action)
    error_message = "Network default action must be 'Allow' or 'Deny'"
  }
}

variable "key_vault_network_bypass" {
  description = "Network services to bypass Key Vault firewall"
  type        = list(string)
  default     = ["AzureServices"]
}

variable "key_vault_create_current_user_policy" {
  description = "Create access policy for current Azure user"
  type        = bool
  default     = true
}

variable "key_vault_create_sample_secret" {
  description = "Create a sample secret in Key Vault for testing"
  type        = bool
  default     = true
}

variable "key_vault_enable_private_endpoint" {
  description = "Enable private endpoint for Key Vault"
  type        = bool
  default     = true
}

variable "key_vault_private_dns_zone_ids" {
  description = "Private DNS zone IDs for Key Vault private endpoint"
  type        = list(string)
  default     = []
}

variable "app_gateway_sku_name" {
  description = "SKU name for Application Gateway"
  type        = string
  default     = "Standard_v2"

  validation {
    condition     = contains(["Standard_v2", "WAF_v2"], var.app_gateway_sku_name)
    error_message = "Application Gateway SKU must be 'Standard_v2' or 'WAF_v2'"
  }
}

variable "app_gateway_sku_tier" {
  description = "SKU tier for Application Gateway"
  type        = string
  default     = "Standard_v2"

  validation {
    condition     = contains(["Standard_v2", "WAF_v2"], var.app_gateway_sku_tier)
    error_message = "Application Gateway SKU tier must be 'Standard_v2' or 'WAF_v2'"
  }
}

variable "app_gateway_capacity" {
  description = "Number of Application Gateway instances"
  type        = number
  default     = 2

  validation {
    condition     = var.app_gateway_capacity >= 1 && var.app_gateway_capacity <= 32
    error_message = "Application Gateway capacity must be between 1 and 32"
  }
}

variable "app_gateway_availability_zones" {
  description = "Availability zones for Application Gateway"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "app_gateway_enable_waf" {
  description = "Enable Web Application Firewall on Application Gateway"
  type        = bool
  default     = true
}

variable "app_gateway_waf_mode" {
  description = "WAF mode (Detection or Prevention)"
  type        = string
  default     = "Prevention"

  validation {
    condition     = contains(["Detection", "Prevention"], var.app_gateway_waf_mode)
    error_message = "WAF mode must be 'Detection' or 'Prevention'"
  }
}

variable "enable_private_endpoints" {
  description = "Enable private endpoints for ACR and Key Vault"
  type        = bool
  default     = true
}

variable "acr_private_dns_zone_ids" {
  description = "Private DNS zone IDs for Container Registry private endpoint"
  type        = list(string)
  default     = []
}

variable "storage_account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "GRS"
}

variable "storage_account_shared_access_key_enabled" {
  description = "Enable shared access key"
  type        = bool
  default     = false
}

variable "storage_account_network_default_action" {
  description = "Storage account network default action"
  type        = string
  default     = "Deny"
}

variable "storage_account_network_bypass" {
  description = "Storage account network bypass"
  type        = list(string)
  default     = ["AzureServices"]
}

variable "storage_account_enable_lifecycle" {
  description = "Enable lifecycle management"
  type        = bool
  default     = true
}

variable "storage_account_enable_private_endpoint" {
  description = "Enable private endpoint for storage"
  type        = bool
  default     = true
}

variable "backup_vault_sku" {
  description = "Backup vault SKU"
  type        = string
  default     = "Standard"
}

variable "backup_vault_immutability_enabled" {
  description = "Enable immutability"
  type        = bool
  default     = true
}

variable "backup_vault_create_vm_policy" {
  description = "Create VM backup policy"
  type        = bool
  default     = true
}

variable "backup_frequency" {
  description = "Backup frequency"
  type        = string
  default     = "Daily"
}

variable "backup_time" {
  description = "Backup time"
  type        = string
  default     = "23:00"
}

variable "backup_retention_daily_count" {
  description = "Daily retention count"
  type        = number
  default     = 7
}

variable "backup_vault_create_db_policy" {
  description = "Create database backup policy"
  type        = bool
  default     = true
}

variable "db_backup_frequency" {
  description = "Database backup frequency"
  type        = string
  default     = "Daily"
}

variable "db_backup_time" {
  description = "Database backup time"
  type        = string
  default     = "22:00"
}

variable "backup_vault_enable_site_recovery" {
  description = "Enable site recovery"
  type        = bool
  default     = false
}

variable "app_insights_retention_days" {
  description = "App Insights retention days"
  type        = number
  default     = 90
}

variable "app_insights_sampling_percentage" {
  description = "App Insights sampling percentage"
  type        = number
  default     = 100
}

variable "app_insights_enable_alerts" {
  description = "Enable App Insights alerts"
  type        = bool
  default     = true
}

variable "app_insights_response_time_threshold" {
  description = "Response time threshold (ms)"
  type        = number
  default     = 2000
}

variable "app_insights_exception_rate_threshold" {
  description = "Exception rate threshold"
  type        = number
  default     = 10
}

variable "app_insights_enable_availability_test" {
  description = "Enable availability tests"
  type        = bool
  default     = true
}

variable "app_insights_availability_test_url" {
  description = "Availability test URL"
  type        = string
  default     = "https://example.com"
}

variable "bastion_subnet_id" {
  description = "Bastion subnet ID"
  type        = string
  default     = ""
}

variable "bastion_sku" {
  description = "Bastion SKU"
  type        = string
  default     = "Standard"
}

variable "enable_container_apps" {
  description = "Enable Azure Container Apps"
  type        = bool
  default     = false
}

variable "enable_function_apps" {
  description = "Enable Azure Function Apps"
  type        = bool
  default     = false
}

variable "function_app_os_type" {
  description = "Function app OS type"
  type        = string
  default     = "Windows"
}

variable "function_app_sku" {
  description = "Function app SKU"
  type        = string
  default     = "Y1"
}

variable "function_app_app_settings" {
  description = "Function app settings"
  type        = map(string)
  default     = {}
}

variable "enable_aks_fleet_manager" {
  description = "Enable AKS Fleet Manager"
  type        = bool
  default     = false
}

