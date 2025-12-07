subscription_id = "2c4130d9-0278-4b5a-8dbf-feaf20816e08"

# Azure Service Principal credentials - Set via environment variables:
# TF_VAR_client_id, TF_VAR_client_secret, TF_VAR_tenant_id
# Or uncomment and provide values below:
client_id       = "c6bb448b-a8d7-4158-9b70-af1e6557b8a4"
client_secret   = "todomicroinfra"
tenant_id       = "0a5f0b79-84bf-4989-a275-0c7d69a0e25f"

# AKS Service Principal credentials - Set via environment variables:
# TF_VAR_sp_client_id, TF_VAR_sp_client_secret
# Or uncomment and provide values below:
sp_client_id     = "c6bb448b-a8d7-4158-9b70-af1e6557b8a4"
sp_client_secret = "todomicroinfra"

location            = "East US"
resource_group_name = "rg-hld-app-dev"
project_name        = "hld-app"
environment         = "dev"

# VNet Configuration
vnet_cidr            = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
enable_nat_gateway   = true
enable_bastion       = false  # Enable if you need secure access
enable_service_endpoints = true

# Compute Configuration
vm_size                   = "Standard_B2s"
vm_image_publisher        = "Canonical"
vm_image_offer            = "0001-com-ubuntu-server-focal"
vm_image_sku              = "20_04-lts-gen2"
vm_image_version          = "Latest"
vm_count                  = 1
vm_admin_username         = "azureuser"
vm_disable_password_authentication = true  # Use SSH keys
user_data                 = ""

# Database Configuration
db_name                       = "appdb_dev"
db_administrator_login        = "sqladmin"
db_administrator_login_password = "ChangeMe@123!"  # IMPORTANT: Use Azure Key Vault in production
db_sku_name                   = "B_Gen5_1"  # Basic tier for DEV
db_storage_mb                 = 5120  # 5 GB
db_version                    = "8.0"
db_backup_retention_days      = 7
db_geo_redundant_backup       = false  # Disabled for DEV to save costs
db_auto_grow_enabled          = true
db_infrastructure_encryption  = true

# Common Tags
common_tags = {
  Environment = "dev"
  Owner       = "DevOps Team"
  CostCenter  = "Engineering"
  Backup      = "false"
  ManagedBy   = "Terraform"
}

# sp_client_id     = "your-sp-client-id"      # Use environment variables
# sp_client_secret = "your-sp-client-secret"  # Use environment variables

kubernetes_version         = "1.27"
aks_node_count             = 2
aks_vm_size                = "Standard_D2s_v3"
aks_availability_zones     = [1, 2, 3]
aks_enable_auto_scaling    = true
aks_min_count              = 2
aks_max_count              = 5
aks_max_pods               = 30
aks_docker_bridge_cidr     = "172.17.0.1/16"
aks_service_cidr           = "10.0.0.0/16"
aks_dns_service_ip         = "10.0.0.10"

# Additional Node Pools for different workloads (optional)
aks_additional_node_pools = [
  # Example worker pool:
  # {
  #   name                = "workerpool"
  #   node_count          = 1
  #   vm_size             = "Standard_D2s_v3"
  #   availability_zones  = [1, 2, 3]
  #   enable_auto_scaling = true
  #   min_count           = 1
  #   max_count           = 3
  #   max_pods            = 30
  #   priority            = "Regular"
  #   labels = {
  #     workload = "general"
  #   }
  # }
]

# Container Registry Configuration

acr_sku               = "Standard"  # Basic for DEV, Standard/Premium for PROD
acr_enable_encryption = false       # Enable encryption in PROD

# Container Registry Webhooks for CI/CD (optional)
acr_webhooks = [
  # Example webhook:
  # {
  #   name        = "github-webhook"
  #   service_uri = "https://your-webhook-url"
  #   events      = ["push", "delete"]
  #   scope       = "*"
  #   status      = "enabled"
  # }
]


# Log Analytics Configuration

log_analytics_sku                    = "PerGB2018"
log_analytics_retention_days         = 30
log_analytics_enable_aks_monitoring  = true
log_analytics_enable_aks_diagnostics = true
log_analytics_enable_alerts          = true
log_analytics_cpu_threshold          = 80
log_analytics_memory_threshold       = 85


# Key Vault Configuration

key_vault_sku_name                   = "standard"
key_vault_purge_protection_enabled   = false  # Disable for easier cleanup in DEV
key_vault_soft_delete_retention_days = 7      # Minimum for DEV
key_vault_network_default_action     = "Allow"  # Open network for DEV
key_vault_create_current_user_policy = true
key_vault_create_sample_secret       = true
key_vault_enable_private_endpoint    = false  # Disabled in DEV to save costs
key_vault_private_dns_zone_ids       = []


# Application Gateway Configuration

app_gateway_sku_name         = "Standard_v2"  # Use WAF_v2 for PROD
app_gateway_sku_tier         = "Standard_v2"
app_gateway_capacity         = 2
app_gateway_availability_zones = ["1", "2"]
app_gateway_enable_waf       = false  # Disable WAF in DEV to reduce costs
app_gateway_waf_mode         = "Detection"


# Private Endpoint Configuration

enable_private_endpoints    = false  # Disabled in DEV to save costs
acr_private_dns_zone_ids    = []
# For PROD: acr_private_dns_zone_ids = ["/subscriptions/.../.../privatelink.azurecr.io"]

