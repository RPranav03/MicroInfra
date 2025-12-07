resource "azurerm_public_ip" "bastion" {
  name                = "${var.bastion_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.availability_zones

  tags = var.tags
}

resource "azurerm_bastion_host" "main" {
  name                = var.bastion_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.bastion_sku

  ip_configuration {
    name                 = "${var.bastion_name}-ipc"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }

  tunneling_enabled           = var.enable_tunneling
  shareable_link_enabled      = var.enable_shareable_link
  copy_paste_enabled          = var.enable_copy_paste
  file_copy_enabled           = var.enable_file_copy
  ip_connect_enabled          = var.enable_ip_connect

  tags = var.tags
}

# Diagnostic settings for audit logging
resource "azurerm_monitor_diagnostic_setting" "bastion" {
  name                       = "${var.bastion_name}-diagnostics"
  target_resource_id         = azurerm_bastion_host.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "BastionAuditLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
