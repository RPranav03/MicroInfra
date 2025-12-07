resource "azurerm_log_analytics_workspace" "main" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days

  tags = var.tags
}

# Solution for AKS monitoring
resource "azurerm_log_analytics_solution" "aks_monitoring" {
  count               = var.enable_aks_monitoring ? 1 : 0
  solution_name       = "ContainerInsights"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_name      = azurerm_log_analytics_workspace.main.name
  workspace_resource_id = azurerm_log_analytics_workspace.main.id

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

# Diagnostic Setting for AKS cluster logs
resource "azurerm_monitor_diagnostic_setting" "aks" {
  count              = var.enable_aks_diagnostics ? 1 : 0
  name               = "${var.workspace_name}-aks-diag"
  target_resource_id = var.aks_cluster_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "kube-apiserver"
  }

  enabled_log {
    category = "kube-controller-manager"
  }

  enabled_log {
    category = "kube-scheduler"
  }

  enabled_log {
    category = "cluster-autoscaler"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Sample alert rule: High CPU usage on cluster
resource "azurerm_monitor_metric_alert" "high_cpu" {
  count               = var.enable_alerts ? 1 : 0
  name                = "${var.workspace_name}-high-cpu-alert"
  resource_group_name = var.resource_group_name
  scopes              = [var.aks_cluster_id]
  description         = "Alert when AKS cluster CPU is high"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_name      = "node_cpu_utilization_percentage"
    metric_namespace = "Insights.Container"
    operator         = "GreaterThan"
    threshold        = var.cpu_threshold_percentage
    aggregation      = "Average"
  }

  dynamic "action" {
    for_each = var.action_group_id != null && var.action_group_id != "" ? [var.action_group_id] : []
    content {
      action_group_id = action.value
    }
  }
}

# Sample alert rule: High memory usage
resource "azurerm_monitor_metric_alert" "high_memory" {
  count               = var.enable_alerts ? 1 : 0
  name                = "${var.workspace_name}-high-memory-alert"
  resource_group_name = var.resource_group_name
  scopes              = [var.aks_cluster_id]
  description         = "Alert when AKS cluster memory is high"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_name      = "node_memory_utilization_percentage"
    metric_namespace = "Insights.Container"
    operator         = "GreaterThan"
    threshold        = var.memory_threshold_percentage
    aggregation      = "Average"
  }

  dynamic "action" {
    for_each = var.action_group_id != null && var.action_group_id != "" ? [var.action_group_id] : []
    content {
      action_group_id = action.value
    }
  }
}
