resource "azurerm_kubernetes_cluster" "main" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name           = var.node_pool_name
    node_count     = var.node_count
    vm_size        = var.vm_size
    zones          = var.availability_zones
    max_pods       = var.max_pods
    vnet_subnet_id = var.subnet_id

    tags = var.tags
  }

  role_based_access_control_enabled = var.rbac_enabled

  network_profile {
    network_plugin    = var.network_plugin
    network_policy    = var.network_policy
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
    load_balancer_sku = var.load_balancer_sku
  }

  http_application_routing_enabled = var.enable_http_app_routing

  dynamic "microsoft_defender" {
    for_each = var.log_analytics_workspace_id != null ? [1] : []
    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  azure_policy_enabled = var.enable_azure_policy

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [default_node_pool[0].node_count]
  }
}

# Azure Container Registry for pushing images
resource "azurerm_container_registry" "main" {
  count               = var.enable_acr ? 1 : 0
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled

  tags = var.tags
}

# Attach ACR to AKS cluster
resource "azurerm_role_assignment" "aks_acr_pull" {
  count              = var.enable_acr ? 1 : 0
  scope              = azurerm_container_registry.main[0].id
  role_definition_name = "AcrPull"
  principal_id       = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

# Get AKS credentials for kubeconfig
resource "null_resource" "get_kubeconfig" {
  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group ${var.resource_group_name} --name ${var.aks_cluster_name} --overwrite-existing"
  }

  depends_on = [azurerm_kubernetes_cluster.main]
}
