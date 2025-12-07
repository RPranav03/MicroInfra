resource "azurerm_public_ip" "appgw" {
  name                = "${var.app_gateway_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.availability_zones

  tags = var.tags
}

resource "azurerm_application_gateway" "main" {
  name                = var.app_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.capacity
  }

  gateway_ip_configuration {
    name      = "${var.app_gateway_name}-ip-config"
    subnet_id = var.app_gateway_subnet_id
  }

  frontend_port {
    name = "http"
    port = 80
  }

  frontend_port {
    name = "https"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "${var.app_gateway_name}-fip"
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  backend_address_pool {
    name = "${var.app_gateway_name}-backend-pool"
  }

  backend_http_settings {
    name                  = "${var.app_gateway_name}-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }

  http_listener {
    name                           = "${var.app_gateway_name}-http-listener"
    frontend_ip_configuration_name = "${var.app_gateway_name}-fip"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${var.app_gateway_name}-routing-rule"
    priority                   = 10
    rule_type                  = "Basic"
    http_listener_name         = "${var.app_gateway_name}-http-listener"
    backend_address_pool_name  = "${var.app_gateway_name}-backend-pool"
    backend_http_settings_name = "${var.app_gateway_name}-http-settings"
  }

  # WAF Policy
  waf_configuration {
    enabled          = var.enable_waf
    firewall_mode    = var.waf_mode
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }

  enable_http2 = true

  tags = var.tags
}

# Managed Identity for AGIC
resource "azurerm_user_assigned_identity" "agic" {
  name                = "${var.app_gateway_name}-agic-mi"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags
}

# Reader role for App Gateway on AKS resource group (AGIC needs to read AKS ingress resources)
resource "azurerm_role_assignment" "agic_reader" {
  scope              = var.aks_resource_group_id
  role_definition_name = "Reader"
  principal_id       = azurerm_user_assigned_identity.agic.principal_id
}

# Contributor role on App Gateway for AGIC to manage it
resource "azurerm_role_assignment" "agic_contributor_appgw" {
  scope              = azurerm_application_gateway.main.id
  role_definition_name = "Contributor"
  principal_id       = azurerm_user_assigned_identity.agic.principal_id
}

# Contributor role on subnet for AGIC
resource "azurerm_role_assignment" "agic_contributor_subnet" {
  scope              = var.app_gateway_subnet_id
  role_definition_name = "Contributor"
  principal_id       = azurerm_user_assigned_identity.agic.principal_id
}
