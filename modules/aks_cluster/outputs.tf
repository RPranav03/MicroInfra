output "aks_cluster_id" {
  description = "The ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.id
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.name
}

output "aks_fqdn" {
  description = "The FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.fqdn
}

output "kube_config_raw" {
  description = "Raw Kubernetes config"
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}

output "client_certificate" {
  description = "Base64 encoded public certificate used by clients to authenticate"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_certificate
  sensitive   = true
}

output "client_key" {
  description = "Base64 encoded private key used by clients to authenticate"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_key
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Base64 encoded public CA certificate used as a root of trust"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate
  sensitive   = true
}

output "kubelet_identity" {
  description = "The identity of the kubelet"
  value       = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

output "acr_id" {
  description = "The ID of the Azure Container Registry"
  value       = try(azurerm_container_registry.main[0].id, null)
}

output "acr_login_server" {
  description = "The login server URL for the Azure Container Registry"
  value       = try(azurerm_container_registry.main[0].login_server, null)
}

output "acr_admin_username" {
  description = "The admin username for the Azure Container Registry"
  value       = try(azurerm_container_registry.main[0].admin_username, null)
  sensitive   = true
}

output "acr_admin_password" {
  description = "The admin password for the Azure Container Registry"
  value       = try(azurerm_container_registry.main[0].admin_password, null)
  sensitive   = true
}
