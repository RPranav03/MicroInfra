resource "azurerm_kubernetes_cluster_node_pool" "main" {
  for_each = { for pool in var.node_pools : pool.name => pool }

  name                  = each.value.name
  kubernetes_cluster_id = var.cluster_id
  node_count            = each.value.enable_auto_scaling ? null : each.value.node_count
  vm_size               = each.value.vm_size
  zones                 = each.value.availability_zones

  min_count           = each.value.enable_auto_scaling ? each.value.min_count : null
  max_count           = each.value.enable_auto_scaling ? each.value.max_count : null

  max_pods              = each.value.max_pods
  vnet_subnet_id        = each.value.subnet_id
  os_sku                = each.value.os_sku
  priority              = each.value.priority
  eviction_policy       = each.value.priority == "Spot" ? each.value.eviction_policy : null
  spot_max_price        = each.value.priority == "Spot" ? each.value.spot_max_price : null

  node_labels = each.value.labels
  node_taints = each.value.taints

  tags = var.tags
}

# Optional: Assign managed identity to node pool
resource "azurerm_role_assignment" "node_pool_managed_identity" {
  for_each = var.assign_managed_identity ? { for pool in var.node_pools : pool.name => pool } : {}

  scope              = var.cluster_id
  role_definition_name = "Contributor"
  principal_id       = var.managed_identity_principal_id
}
