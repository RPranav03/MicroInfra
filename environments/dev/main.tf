locals {
  environment_name = "dev"
  
  # Cost optimization settings
  cost_optimization = {
    use_spot_instances = false
    delete_on_termination = true
    minimal_instances = 1
  }

  # Backup and retention settings
  backup_config = {
    retention_days = 1
    backup_enabled = true
    snapshot_enabled = false
  }

  # Monitoring settings
  monitoring = {
    detailed_monitoring = false
    log_retention_days = 7
  }

  # Networking settings
  network_config = {
    nat_gateway_count = 1  # Single NAT for cost optimization
    vpn_enabled = false
  }
}

# Data source to get current Azure context (for Key Vault RBAC)
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    CreatedAt   = formatdate("YYYY-MM-DD", timestamp())
  }
}

# Virtual Network
module "virtual_network" {
  source = "../../modules/virtual_network"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  vnet_cidr           = var.vnet_cidr

  tags = var.common_tags
}

# Subnets
module "subnets" {
  source = "../../modules/subnets"

  project_name                = var.project_name
  environment                 = var.environment
  resource_group_name         = azurerm_resource_group.main.name
  vnet_name                   = module.virtual_network.vnet_name
  public_subnet_cidrs         = var.public_subnet_cidrs
  private_subnet_cidrs        = var.private_subnet_cidrs
  enable_service_endpoints    = var.enable_service_endpoints

  depends_on = [module.virtual_network]
}

# NAT Gateway
module "nat_gateway" {
  source = "../../modules/nat_gateway"

  project_name            = var.project_name
  environment             = var.environment
  location                = var.location
  resource_group_name     = azurerm_resource_group.main.name
  enable_nat_gateway      = var.enable_nat_gateway
  private_subnet_ids      = module.subnets.private_subnet_ids

  depends_on = [module.subnets]
}

# Network Security Group 
module "nsg_app" {
  source = "../../modules/network_security_group"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  nsg_name            = "${var.project_name}-${var.environment}-app-nsg"
  rules               = var.app_nsg_rules

  tags = var.common_tags
}

# Network Security Group (Database Tier)
module "nsg_database" {
  source = "../../modules/network_security_group"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  nsg_name            = "${var.project_name}-${var.environment}-db-nsg"
  rules               = var.database_nsg_rules

  tags = var.common_tags
}

# Public IPs
module "public_ip" {
  source = "../../modules/public_ip"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  ip_count            = var.vm_count
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.common_tags
}

# Network Interfaces
module "network_interface" {
  source = "../../modules/network_interface"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  nic_count           = var.vm_count
  subnet_id           = module.subnets.private_subnet_ids[0]
  assign_public_ip    = true
  public_ip_ids       = module.public_ip.public_ip_ids

  depends_on = [module.subnets, module.public_ip]
}

# Virtual Machines
module "virtual_machine" {
  source = "../../modules/virtual_machine"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  vm_count            = var.vm_count
  vm_size             = var.vm_size
  image_publisher     = var.vm_image_publisher
  image_offer         = var.vm_image_offer
  image_sku           = var.vm_image_sku
  image_version       = var.vm_image_version
  nic_ids             = module.network_interface.nic_ids
  admin_username      = var.vm_admin_username
  disable_password_authentication = var.vm_disable_password_authentication
  os_disk_type        = "Premium_LRS"
  os_disk_size_gb     = 30

  depends_on = [module.network_interface]

  tags = var.common_tags
}

# Azure Kubernetes Service (AKS) Cluster
module "aks_cluster" {
  source = "../../modules/aks_cluster"

  aks_cluster_name      = "${var.project_name}-aks-${var.environment}"
  location              = var.location
  resource_group_name   = azurerm_resource_group.main.name
  dns_prefix            = "${var.project_name}-${var.environment}"
  kubernetes_version    = var.kubernetes_version
  node_pool_name        = "systempool"
  node_count            = var.aks_node_count
  vm_size               = var.aks_vm_size
  availability_zones    = var.aks_availability_zones
  enable_auto_scaling   = var.aks_enable_auto_scaling
  min_count             = var.aks_min_count
  max_count             = var.aks_max_count
  max_pods              = var.aks_max_pods
  subnet_id             = module.subnets.private_subnet_ids[0]
  client_id             = var.sp_client_id
  client_secret         = var.sp_client_secret
  rbac_enabled          = true
  network_plugin        = "azure"
  network_policy        = "azure"
  docker_bridge_cidr    = var.aks_docker_bridge_cidr
  service_cidr          = var.aks_service_cidr
  dns_service_ip        = var.aks_dns_service_ip
  load_balancer_sku     = "standard"
  enable_http_app_routing = true
  enable_monitoring     = true
  log_analytics_workspace_id = null
  enable_azure_policy   = true
  enable_kube_dashboard = true
  enable_acr            = true
  acr_name              = "${replace(var.project_name, "-", "")}acr${var.environment}"
  acr_sku               = var.acr_sku
  acr_admin_enabled     = true

  tags = var.common_tags

  depends_on = [module.subnets, module.nsg_app, module.nsg_database]
}

# Container Registry Module
module "container_registry" {
  source = "../../modules/container_registry"

  acr_name              = "${replace(var.project_name, "-", "")}acr${var.environment}"
  resource_group_name   = azurerm_resource_group.main.name
  location              = var.location
  sku                   = var.acr_sku
  admin_enabled         = true
  enable_encryption     = var.acr_enable_encryption
  key_vault_key_id      = null
  create_managed_identity = true
  webhooks              = var.acr_webhooks

  tags = var.common_tags

  depends_on = [azurerm_resource_group.main]
}

# AKS Node Pools (optional worker pools for different workloads)
module "aks_node_pool" {
  count  = length(var.aks_additional_node_pools) > 0 ? 1 : 0
  source = "../../modules/aks_node_pool"

  cluster_id                  = module.aks_cluster.aks_cluster_id
  node_pools                  = var.aks_additional_node_pools
  assign_managed_identity     = true
  managed_identity_principal_id = module.aks_cluster.kubelet_identity

  tags = var.common_tags

  depends_on = [module.aks_cluster]
}

# MySQL Server
module "mysql_server" {
  source = "../../modules/mysql_server"

  project_name                 = var.project_name
  environment                  = var.environment
  location                     = var.location
  resource_group_name          = azurerm_resource_group.main.name
  administrator_login          = var.db_administrator_login
  administrator_login_password = var.db_administrator_login_password
  sku_name                     = var.db_sku_name
  storage_mb                   = var.db_storage_mb
  database_version             = var.db_version
  backup_retention_days        = var.db_backup_retention_days
  geo_redundant_backup_enabled = var.db_geo_redundant_backup
  auto_grow_enabled            = var.db_auto_grow_enabled
  public_network_access_enabled = false
  ssl_enforcement_enabled      = true
  infra_encryption_enabled     = var.db_infrastructure_encryption

  tags = var.common_tags
}

# MySQL Database
module "mysql_database" {
  source = "../../modules/mysql_database"

  resource_group_name = azurerm_resource_group.main.name
  server_name         = module.mysql_server.mysql_server_name
  database_name       = var.db_name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"

  depends_on = [module.mysql_server]
}

# MySQL Firewall Rules
module "mysql_firewall_rule" {
  source = "../../modules/mysql_firewall_rule"

  resource_group_name = azurerm_resource_group.main.name
  server_name         = module.mysql_server.mysql_server_name
  firewall_rules      = var.db_firewall_rules

  depends_on = [module.mysql_server]
}

# Log Analytics Workspace for AKS monitoring
module "log_analytics" {
  source = "../../modules/log_analytics"

  workspace_name                = "${var.project_name}-logs-${var.environment}"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.main.name
  sku                           = var.log_analytics_sku
  retention_in_days             = var.log_analytics_retention_days
  enable_aks_monitoring         = var.log_analytics_enable_aks_monitoring
  enable_aks_diagnostics        = var.log_analytics_enable_aks_diagnostics
  enable_alerts                 = var.log_analytics_enable_alerts
  aks_cluster_id                = module.aks_cluster.aks_cluster_id
  action_group_id               = null
  cpu_threshold_percentage      = var.log_analytics_cpu_threshold
  memory_threshold_percentage   = var.log_analytics_memory_threshold

  tags = var.common_tags

  depends_on = [module.aks_cluster, azurerm_resource_group.main]
}

# Azure Key Vault for storing secrets, certificates, and keys
module "key_vault" {
  source = "../../modules/key_vault"

  key_vault_name                  = "${replace(var.project_name, "-", "")}kv${var.environment}"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.main.name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = var.key_vault_sku_name
  purge_protection_enabled        = var.key_vault_purge_protection_enabled
  soft_delete_retention_days      = var.key_vault_soft_delete_retention_days
  network_default_action          = var.key_vault_network_default_action
  network_bypass                  = var.key_vault_network_bypass
  create_current_user_policy      = var.key_vault_create_current_user_policy
  current_user_object_id          = data.azurerm_client_config.current.object_id
  aks_managed_identity_object_id  = module.aks_cluster.kubelet_identity
  acr_managed_identity_object_id  = module.container_registry.identity_principal_id
  create_sample_secret            = var.key_vault_create_sample_secret
  enable_private_endpoint         = var.key_vault_enable_private_endpoint
  private_endpoint_subnet_id      = var.key_vault_enable_private_endpoint ? module.subnets.private_subnet_ids[1] : null
  private_dns_zone_ids            = var.key_vault_private_dns_zone_ids

  tags = var.common_tags

  depends_on = [module.aks_cluster, module.container_registry, azurerm_resource_group.main]
}

# Azure Application Gateway with WAF for AKS ingress
module "application_gateway" {
  source = "../../modules/application_gateway"

  app_gateway_name       = "${var.project_name}-appgw-${var.environment}"
  location               = var.location
  resource_group_name    = azurerm_resource_group.main.name
  app_gateway_subnet_id  = module.subnets.public_subnet_ids[0]
  sku_name               = var.app_gateway_sku_name
  sku_tier               = var.app_gateway_sku_tier
  capacity               = var.app_gateway_capacity
  availability_zones     = var.app_gateway_availability_zones
  enable_waf             = var.app_gateway_enable_waf
  waf_mode               = var.app_gateway_waf_mode
  aks_resource_group_id  = azurerm_resource_group.main.id

  tags = var.common_tags

  depends_on = [module.subnets, module.aks_cluster]
}

# Private Endpoint for Container Registry (secure access without public IP)
module "private_endpoint_acr" {
  count  = var.enable_private_endpoints ? 1 : 0
  source = "../../modules/private_endpoint"

  private_endpoint_name          = "${var.project_name}-acr-pe-${var.environment}"
  location                       = var.location
  resource_group_name            = azurerm_resource_group.main.name
  subnet_id                      = module.subnets.private_subnet_ids[0]
  private_connection_resource_id = module.container_registry.registry_id
  subresource_names              = ["registry"]
  enable_private_dns_zone_group  = true
  private_dns_zone_ids           = var.acr_private_dns_zone_ids

  tags = var.common_tags

  depends_on = [module.container_registry, module.subnets]
}

# Private Endpoint for Key Vault (secure access without public IP)
module "private_endpoint_kv" {
  count  = var.enable_private_endpoints ? 1 : 0
  source = "../../modules/private_endpoint"

  private_endpoint_name          = "${var.project_name}-kv-pe-${var.environment}"
  location                       = var.location
  resource_group_name            = azurerm_resource_group.main.name
  subnet_id                      = module.subnets.private_subnet_ids[1]
  private_connection_resource_id = module.key_vault.key_vault_id
  subresource_names              = ["vault"]
  enable_private_dns_zone_group  = true
  private_dns_zone_ids           = var.key_vault_private_dns_zone_ids

  tags = var.common_tags

  depends_on = [module.key_vault, module.subnets]
}

# Azure Storage Account for data/logs/backups
module "storage_account" {
  source = "../../modules/storage_account"

  storage_account_name           = "${replace(var.project_name, "-", "")}storage${var.environment}"
  resource_group_name            = azurerm_resource_group.main.name
  location                       = var.location
  account_tier                   = var.storage_account_tier
  account_replication_type       = var.storage_account_replication_type
  shared_access_key_enabled      = var.storage_account_shared_access_key_enabled
  network_default_action         = var.storage_account_network_default_action
  network_bypass                 = var.storage_account_network_bypass
  allowed_subnet_ids             = [module.subnets.private_subnet_ids[0]]
  create_blob_containers         = true
  enable_lifecycle_management    = var.storage_account_enable_lifecycle
  enable_private_endpoint        = var.storage_account_enable_private_endpoint
  private_endpoint_subnet_id     = var.storage_account_enable_private_endpoint ? module.subnets.private_subnet_ids[1] : ""

  tags = var.common_tags

  depends_on = [module.subnets]
}

# Backup Vault for disaster recovery
module "backup_vault" {
  source = "../../modules/backup_vault"

  backup_vault_name              = "${var.project_name}-backup-${var.environment}"
  resource_group_name            = azurerm_resource_group.main.name
  location                       = var.location
  vault_sku                      = var.backup_vault_sku
  immutability_enabled           = var.backup_vault_immutability_enabled
  create_vm_backup_policy        = var.backup_vault_create_vm_policy
  backup_frequency               = var.backup_frequency
  backup_time                    = var.backup_time
  retention_daily_count          = var.backup_retention_daily_count
  create_database_backup_policy  = var.backup_vault_create_db_policy
  db_backup_frequency            = var.db_backup_frequency
  db_backup_time                 = var.db_backup_time
  enable_site_recovery           = var.backup_vault_enable_site_recovery

  tags = var.common_tags

  depends_on = [azurerm_resource_group.main]
}

# Application Insights for APM (Application Performance Monitoring)
module "application_insights" {
  source = "../../modules/application_insights"

  app_insights_name              = "${var.project_name}-ai-${var.environment}"
  resource_group_name            = azurerm_resource_group.main.name
  location                       = var.location
  application_type               = "web"
  log_analytics_workspace_id     = module.log_analytics.workspace_id
  retention_in_days              = var.app_insights_retention_days
  sampling_percentage            = var.app_insights_sampling_percentage
  enable_alerts                  = var.app_insights_enable_alerts
  action_group_id                = null
  response_time_threshold_ms     = var.app_insights_response_time_threshold
  exception_rate_threshold       = var.app_insights_exception_rate_threshold
  enable_availability_test       = var.app_insights_enable_availability_test
  availability_test_url          = var.app_insights_availability_test_url

  tags = var.common_tags

  depends_on = [module.log_analytics]
}

# Azure Bastion for secure VM access
module "bastion" {
  count = var.enable_bastion ? 1 : 0
  source = "../../modules/bastion"

  bastion_name                   = "${var.project_name}-bastion-${var.environment}"
  resource_group_name            = azurerm_resource_group.main.name
  location                       = var.location
  bastion_subnet_id              = var.bastion_subnet_id != "" ? var.bastion_subnet_id : module.subnets.public_subnet_ids[0]
  bastion_sku                    = var.bastion_sku
  enable_tunneling               = true
  enable_shareable_link          = true
  enable_copy_paste              = true
  enable_file_copy               = true
  log_analytics_workspace_id     = module.log_analytics.workspace_id

  tags = var.common_tags

  depends_on = [module.subnets, module.log_analytics]
}

# Azure Container Apps for lightweight containerized apps
module "container_apps" {
  count = var.enable_container_apps ? 1 : 0
  source = "../../modules/container_apps"

  container_app_env_name         = "${var.project_name}-acaenv-${var.environment}"
  resource_group_name            = azurerm_resource_group.main.name
  location                       = var.location
  log_analytics_workspace_id     = module.log_analytics.workspace_id
  infrastructure_subnet_id       = module.subnets.private_subnet_ids[0]
  enable_internal_load_balancer  = true

  tags = var.common_tags

  depends_on = [module.subnets, module.log_analytics]
}

# Azure Function Apps for serverless functions
module "function_app" {
  count = var.enable_function_apps ? 1 : 0
  source = "../../modules/function_app"

  app_service_plan_name          = "${var.project_name}-funcplan-${var.environment}"
  function_app_name              = "${var.project_name}-func-${var.environment}"
  resource_group_name            = azurerm_resource_group.main.name
  location                       = var.location
  os_type                        = var.function_app_os_type
  sku_name                       = var.function_app_sku
  storage_account_name           = module.storage_account.storage_account_name
  storage_account_access_key     = module.storage_account.primary_access_key
  app_insights_instrumentation_key = module.application_insights.app_insights_instrumentation_key
  app_settings                   = var.function_app_app_settings

  tags = var.common_tags

  depends_on = [module.storage_account, module.application_insights]
}

# AKS Fleet Manager for managing multiple AKS clusters
module "aks_fleet_manager" {
  count = var.enable_aks_fleet_manager ? 1 : 0
  source = "../../modules/aks_fleet_manager"

  fleet_manager_name             = "${var.project_name}-fleet-${var.environment}"
  resource_group_name            = azurerm_resource_group.main.name
  location                       = var.location

  tags = var.common_tags

  depends_on = [module.aks_cluster]
}

