# AKS Fleet Manager is managed through azurerm_kubernetes_fleet_manager resource
# For now, this module serves as a placeholder for future multi-cluster management
# Users can manage fleet relationships through the Azure Portal or CLI

locals {
  fleet_manager_note = "AKS Fleet Manager can be managed via Azure CLI: az fleet create"
}
