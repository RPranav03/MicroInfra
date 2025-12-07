# Azure Authentication (Use environment variables: ARM_SUBSCRIPTION_ID, ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_TENANT_ID)
# subscription_id = "your-subscription-id"
# client_id       = "your-client-id"
# client_secret   = "your-client-secret"
# tenant_id       = "your-tenant-id"

location            = "East US"
resource_group_name = "rg-hld-app-qa"
project_name        = "hld-app"
environment         = "qa"

vnet_cidr            = "10.1.0.0/16"
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.10.0/24", "10.1.11.0/24"]
enable_nat_gateway   = true
enable_bastion       = false  # Enable if you need secure access
enable_service_endpoints = true


vm_size                   = "Standard_B2s"
vm_image_publisher        = "Canonical"
vm_image_offer            = "0001-com-ubuntu-server-focal"
vm_image_sku              = "20_04-lts-gen2"
vm_image_version          = "Latest"
vm_count                  = 2  # HA for QA
vm_admin_username         = "azureuser"
vm_disable_password_authentication = true  # Use SSH keys
user_data                 = ""


db_name                       = "appdb_qa"
db_administrator_login        = "sqladmin"
db_administrator_login_password = "ChangeMe@123!"  # IMPORTANT: Use Azure Key Vault in production
db_sku_name                   = "GP_Gen5_2"  # General Purpose tier for QA
db_storage_mb                 = 10240  # 10 GB
db_version                    = "8.0"
db_backup_retention_days      = 14  # Longer retention for QA
db_geo_redundant_backup       = true  # Enabled for QA
db_auto_grow_enabled          = true
db_infrastructure_encryption  = true


common_tags = {
  Environment = "qa"
  Owner       = "DevOps Team"
  CostCenter  = "QA"
  Backup      = "true"
  ManagedBy   = "Terraform"
}


# AKS Configuration

# sp_client_id     = "your-sp-client-id"    
# sp_client_secret = "your-sp-client-secret"  

kubernetes_version         = "1.27"
aks_node_count             = 3
aks_vm_size                = "Standard_D3s_v3"
aks_availability_zones     = [1, 2, 3]
aks_enable_auto_scaling    = true
aks_min_count              = 3
aks_max_count              = 8
aks_max_pods               = 30
aks_docker_bridge_cidr     = "172.17.0.1/16"
aks_service_cidr           = "10.1.0.0/16"
aks_dns_service_ip         = "10.1.0.10"

# Additional Node Pools for different workloads
aks_additional_node_pools = [
  {
    name                = "workerpool"
    node_count          = 2
    vm_size             = "Standard_D3s_v3"
    availability_zones  = [1, 2, 3]
    enable_auto_scaling = true
    min_count           = 2
    max_count           = 5
    max_pods            = 30
    priority            = "Regular"
    labels = {
      workload = "general"
    }
  }
]

# Container Registry Configuration
acr_sku               = "Standard"  # Standard for QA
acr_enable_encryption = true        # Enable encryption for QA

# Container Registry Webhooks for CI/CD
acr_webhooks = []  # Configure as needed

# Log Analytics Configuration
log_analytics_sku                    = "PerGB2018"
log_analytics_retention_days         = 60  # Longer retention for QA
log_analytics_enable_aks_monitoring  = true
log_analytics_enable_aks_diagnostics = true
log_analytics_enable_alerts          = true
log_analytics_cpu_threshold          = 75
log_analytics_memory_threshold       = 80

# Key Vault Configuration
key_vault_sku_name                   = "standard"
key_vault_purge_protection_enabled   = true   # Enable for QA
key_vault_soft_delete_retention_days = 30
key_vault_network_default_action     = "Deny"  # Restrict network for QA (production-like)
key_vault_create_current_user_policy = true
key_vault_create_sample_secret       = true
key_vault_enable_private_endpoint    = true   # Enable PE for QA (production-like)
key_vault_private_dns_zone_ids       = []     # Configure with your private DNS zones


# Application Gateway Configuration

app_gateway_sku_name         = "WAF_v2"  # Use WAF for QA (production-like)
app_gateway_sku_tier         = "WAF_v2"
app_gateway_capacity         = 3        # Higher capacity for QA
app_gateway_availability_zones = ["1", "2", "3"]
app_gateway_enable_waf       = true     # Enable WAF for QA
app_gateway_waf_mode         = "Prevention"  # Production mode for QA


# Private Endpoint Configuration

enable_private_endpoints    = true     # Enable in QA (production-like)
acr_private_dns_zone_ids    = []       # Configure with your private DNS zones
# For PROD: acr_private_dns_zone_ids = ["/subscriptions/.../.../privatelink.azurecr.io"]

