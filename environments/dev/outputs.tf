output "resource_group_id" {
  description = "Resource Group ID"
  value       = azurerm_resource_group.main.id
}

output "resource_group_name" {
  description = "Resource Group name"
  value       = azurerm_resource_group.main.name
}

output "virtual_network_outputs" {
  description = "Virtual Network module outputs"
  value = {
    vnet_id   = module.virtual_network.vnet_id
    vnet_name = module.virtual_network.vnet_name
    vnet_cidr = module.virtual_network.vnet_cidr
  }
}

output "subnets_outputs" {
  description = "Subnets module outputs"
  value = {
    public_subnet_ids   = module.subnets.public_subnet_ids
    private_subnet_ids  = module.subnets.private_subnet_ids
    public_subnet_names = module.subnets.public_subnet_names
    private_subnet_names = module.subnets.private_subnet_names
  }
}

output "nat_gateway_outputs" {
  description = "NAT Gateway module outputs"
  value = {
    nat_gateway_id  = module.nat_gateway.nat_gateway_id
    nat_gateway_pip = module.nat_gateway.nat_gateway_public_ip
    public_ip_id    = module.nat_gateway.public_ip_id
  }
}

output "nsg_app_outputs" {
  description = "App NSG module outputs"
  value = {
    nsg_id   = module.nsg_app.nsg_id
    nsg_name = module.nsg_app.nsg_name
  }
}

output "nsg_database_outputs" {
  description = "Database NSG module outputs"
  value = {
    nsg_id   = module.nsg_database.nsg_id
    nsg_name = module.nsg_database.nsg_name
  }
}

output "public_ip_outputs" {
  description = "Public IP module outputs"
  value = {
    public_ip_ids      = module.public_ip.public_ip_ids
    public_ip_addresses = module.public_ip.public_ip_addresses
  }
}

output "network_interface_outputs" {
  description = "Network Interface module outputs"
  value = {
    nic_ids     = module.network_interface.nic_ids
    nic_names   = module.network_interface.nic_names
    private_ips = module.network_interface.private_ips
  }
}

output "virtual_machine_outputs" {
  description = "Virtual Machine module outputs"
  value = {
    vm_ids   = module.virtual_machine.vm_ids
    vm_names = module.virtual_machine.vm_names
  }
}

output "mysql_server_outputs" {
  description = "MySQL Server module outputs"
  value = {
    mysql_server_id   = module.mysql_server.mysql_server_id
    mysql_server_fqdn = module.mysql_server.mysql_server_fqdn
    mysql_server_name = module.mysql_server.mysql_server_name
  }
  sensitive = true
}

output "mysql_database_outputs" {
  description = "MySQL Database module outputs"
  value = {
    database_id   = module.mysql_database.database_id
    database_name = module.mysql_database.database_name
  }
}

output "mysql_firewall_outputs" {
  description = "MySQL Firewall Rules module outputs"
  value = {
    firewall_rule_ids = module.mysql_firewall_rule.firewall_rule_ids
  }
}

output "aks_cluster_outputs" {
  description = "AKS Cluster module outputs"
  value = {
    cluster_id       = module.aks_cluster.aks_cluster_id
    cluster_name     = module.aks_cluster.aks_cluster_name
    cluster_fqdn     = module.aks_cluster.aks_fqdn
    kube_config_raw  = module.aks_cluster.kube_config_raw
    kubelet_identity = module.aks_cluster.kubelet_identity
  }
  sensitive = true
}

output "container_registry_outputs" {
  description = "Container Registry module outputs"
  value = {
    registry_id       = module.container_registry.registry_id
    registry_name     = module.container_registry.registry_name
    login_server      = module.container_registry.login_server
    admin_username    = module.container_registry.admin_username
    admin_password    = module.container_registry.admin_password
    managed_identity  = module.container_registry.managed_identity_id
  }
  sensitive = true
}

output "aks_node_pool_outputs" {
  description = "AKS Node Pool module outputs"
  value = try({
    node_pool_ids   = module.aks_node_pool[0].node_pool_ids
    node_pool_names = module.aks_node_pool[0].node_pool_names
  }, {})
}


output "log_analytics_outputs" {
  description = "Log Analytics Workspace module outputs"
  value = {
    workspace_id            = module.log_analytics.workspace_id
    workspace_name          = module.log_analytics.workspace_name
    workspace_resource_id   = module.log_analytics.workspace_resource_id
    workspace_customer_id   = module.log_analytics.workspace_customer_id
  }
  sensitive = true
}


output "key_vault_outputs" {
  description = "Key Vault module outputs"
  value = {
    key_vault_id       = module.key_vault.key_vault_id
    key_vault_name     = module.key_vault.key_vault_name
    key_vault_uri      = module.key_vault.key_vault_uri
    key_vault_tenant_id = module.key_vault.key_vault_tenant_id
    private_endpoint_id = try(module.key_vault.private_endpoint_id, "")
  }
  sensitive = true
}


output "application_gateway_outputs" {
  description = "Application Gateway module outputs"
  value = {
    app_gateway_id              = module.application_gateway.app_gateway_id
    app_gateway_name            = module.application_gateway.app_gateway_name
    app_gateway_public_ip       = module.application_gateway.app_gateway_public_ip
    app_gateway_backend_pool_id = module.application_gateway.app_gateway_backend_pool_id
    agic_managed_identity_id    = module.application_gateway.agic_managed_identity_id
    agic_managed_identity_principal_id = module.application_gateway.agic_managed_identity_principal_id
    agic_managed_identity_client_id    = module.application_gateway.agic_managed_identity_client_id
  }
}


output "private_endpoint_acr_outputs" {
  description = "Private Endpoint for ACR outputs"
  value = try({
    private_endpoint_id      = module.private_endpoint_acr[0].private_endpoint_id
    private_endpoint_name    = module.private_endpoint_acr[0].private_endpoint_name
    private_ip_address       = module.private_endpoint_acr[0].private_ip_address
    network_interface_id     = module.private_endpoint_acr[0].network_interface_id
    private_dns_zone_group_id = module.private_endpoint_acr[0].private_dns_zone_group_id
  }, {})
}

output "private_endpoint_kv_outputs" {
  description = "Private Endpoint for Key Vault outputs"
  value = try({
    private_endpoint_id      = module.private_endpoint_kv[0].private_endpoint_id
    private_endpoint_name    = module.private_endpoint_kv[0].private_endpoint_name
    private_ip_address       = module.private_endpoint_kv[0].private_ip_address
    network_interface_id     = module.private_endpoint_kv[0].network_interface_id
    private_dns_zone_group_id = module.private_endpoint_kv[0].private_dns_zone_group_id
  }, {})
}


output "storage_account_outputs" {
  description = "Storage Account outputs"
  value = {
    storage_account_id       = module.storage_account.storage_account_id
    storage_account_name     = module.storage_account.storage_account_name
    primary_blob_endpoint    = module.storage_account.primary_blob_endpoint
    blob_container_ids       = module.storage_account.blob_container_ids
  }
  sensitive = true
}

output "backup_vault_outputs" {
  description = "Backup Vault outputs"
  value = {
    backup_vault_id          = module.backup_vault.backup_vault_id
    backup_vault_name        = module.backup_vault.backup_vault_name
    vm_backup_policy_id      = module.backup_vault.vm_backup_policy_id
    database_backup_policy_id = module.backup_vault.database_backup_policy_id
  }
}


output "application_insights_outputs" {
  description = "Application Insights outputs"
  value = {
    app_insights_id                = module.application_insights.app_insights_id
    app_insights_name              = module.application_insights.app_insights_name
    app_insights_instrumentation_key = module.application_insights.app_insights_instrumentation_key
    app_insights_connection_string = module.application_insights.app_insights_connection_string
  }
  sensitive = true
}


output "bastion_outputs" {
  description = "Azure Bastion outputs"
  value = try({
    bastion_id        = module.bastion[0].bastion_id
    bastion_name      = module.bastion[0].bastion_name
    bastion_public_ip = module.bastion[0].bastion_public_ip
  }, {})
}


output "container_apps_outputs" {
  description = "Azure Container Apps outputs"
  value = try({
    container_app_env_id   = module.container_apps[0].container_app_env_id
    container_app_env_name = module.container_apps[0].container_app_env_name
  }, {})
}

output "function_app_outputs" {
  description = "Azure Function Apps outputs"
  value = try({
    function_app_id              = module.function_app[0].function_app_id
    function_app_name            = module.function_app[0].function_app_name
    function_app_default_hostname = module.function_app[0].function_app_default_hostname
    app_service_plan_id          = module.function_app[0].app_service_plan_id
  }, {})
}


output "aks_fleet_manager_outputs" {
  description = "AKS Fleet Manager outputs"
  value = try({
    fleet_manager_id   = module.aks_fleet_manager[0].fleet_manager_id
    fleet_manager_name = module.aks_fleet_manager[0].fleet_manager_name
  }, {})
}

