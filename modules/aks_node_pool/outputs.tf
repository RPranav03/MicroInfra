output "node_pool_ids" {
  description = "IDs of the created node pools"
  value       = { for k, v in azurerm_kubernetes_cluster_node_pool.main : k => v.id }
}

output "node_pool_names" {
  description = "Names of the created node pools"
  value       = [for pool in azurerm_kubernetes_cluster_node_pool.main : pool.name]
}
