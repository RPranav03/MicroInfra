resource "azurerm_application_insights" "main" {
  name                = var.app_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.application_type
  workspace_id        = var.log_analytics_workspace_id
  retention_in_days   = var.retention_in_days
  sampling_percentage = var.sampling_percentage
  daily_data_cap_in_gb = var.daily_data_cap_in_gb

  tags = var.tags
}

# Metric alerts for application performance (simplified - requires Azure Alert Rules)
# These are placeholder structures - use Azure Monitor directly for metric-based alerts

# Alert for high exception rate
resource "azurerm_monitor_metric_alert" "exception_rate" {
  count               = var.enable_alerts ? 1 : 0
  name                = "${var.app_insights_name}-high-exception-rate"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_insights.main.id]
  description         = "Alert when exception rate is high"
  severity            = 3
  enabled             = true
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace       = "Microsoft.Insights/components"
    metric_name            = "requests/failed"
    aggregation            = "Count"
    operator               = "GreaterThan"
    threshold              = var.exception_rate_threshold
    skip_metric_validation = true
  }

  dynamic "action" {
    for_each = var.action_group_id != null && var.action_group_id != "" ? [var.action_group_id] : []
    content {
      action_group_id = action.value
    }
  }
}

# Diagnostic settings to send logs to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "app_insights" {
  name                           = "${var.app_insights_name}-diagnostics"
  target_resource_id             = azurerm_application_insights.main.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  enabled_log {
    category = "AppServiceAppLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Availability test for synthetic monitoring
resource "azurerm_application_insights_web_test" "availability" {
  count                   = var.enable_availability_test ? 1 : 0
  name                    = "${var.app_insights_name}-availability-test"
  location                = var.location
  resource_group_name     = var.resource_group_name
  application_insights_id = azurerm_application_insights.main.id
  kind                    = "ping"
  frequency               = 300  # 5 minutes
  timeout                 = 30
  enabled                 = true

  geo_locations = var.availability_test_locations

  configuration = <<XML
<WebTest Name="AppAvailabilityTest" Description="" UseSSL="true" Timeout="30" ParseDependentRequests="true" FollowRedirects="true" RetryOnFailed="true" Enabled="true" CacheControl="no-cache" ContentType="" ExpectedHttpStatusCode="200" ExpectedContentMatch="" IgnoreHttpStatusCode="false" DeriveSyntheticMonitorID="true" Proxy="default" StopOnRedirect="false" RecordedUserId="">
  <Items>
    <Request Method="GET" Version="1.1" Url="{var.availability_test_url}" ThinkTime="0" Timeout="30" ParseDependentRequests="true" FollowRedirects="true" RecordResult="true" Cache="false" ResponseTimeGoal="0" Encoding="utf-8" ExpectedHttpStatusCode="200" ExpectedContentMatch="" IgnoreHttpStatusCode="false" />
  </Items>
</WebTest>
XML

  tags = var.tags
}

# Alert for availability test failures
resource "azurerm_monitor_metric_alert" "availability_failure" {
  count               = var.enable_availability_test && var.enable_alerts ? 1 : 0
  name                = "${var.app_insights_name}-availability-failure"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_insights_web_test.availability[0].id]
  description         = "Alert when availability test fails"
  severity            = 1
  enabled             = true
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace       = "Microsoft.Insights/webTestLocationAvailabilityResults"
    metric_name            = "availabilityResults/availabilityPercentage"
    aggregation            = "Average"
    operator               = "LessThan"
    threshold              = 100
    skip_metric_validation = true
  }

  dynamic "action" {
    for_each = var.action_group_id != null && var.action_group_id != "" ? [var.action_group_id] : []
    content {
      action_group_id = action.value
    }
  }
}
