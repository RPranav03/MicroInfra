resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.sku_name

  tags = var.tags
}

resource "azurerm_windows_function_app" "main" {
  count               = var.os_type == "Windows" ? 1 : 0
  name                = var.function_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id

  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  site_config {
    application_stack {
      dotnet_version = "v6.0"
    }
  }

  app_settings = merge(
    var.app_settings,
    {
      "FUNCTIONS_EXTENSION_VERSION"         = "~4"
      "WEBSITE_NODE_DEFAULT_VERSION"        = "~16"
      "APPINSIGHTS_INSTRUMENTATIONKEY"      = var.app_insights_instrumentation_key
      "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    }
  )

  identity {
    type = "SystemAssigned"
  }

  https_only = true

  tags = var.tags
}

resource "azurerm_linux_function_app" "main" {
  count               = var.os_type == "Linux" ? 1 : 0
  name                = var.function_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id

  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  site_config {
    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = merge(
    var.app_settings,
    {
      "FUNCTIONS_EXTENSION_VERSION"         = "~4"
      "WEBSITE_PYTHON_VERSION"              = "3.11"
      "APPINSIGHTS_INSTRUMENTATIONKEY"      = var.app_insights_instrumentation_key
      "ApplicationInsightsAgent_EXTENSION_VERSION" = "~4"
    }
  )

  identity {
    type = "SystemAssigned"
  }

  https_only = true

  tags = var.tags
}
