locals {
  common_tags = merge(
    {
      Name        = var.nsg_name
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    },
    var.tags
  )

  # Flatten rules
  rules = [
    for rule in var.rules : merge(
      rule,
      {}
    )
  ]
}

# Network Security Group
resource "azurerm_network_security_group" "main" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = local.common_tags
}

# NSG Rules
resource "azurerm_network_security_rule" "main" {
  for_each = {
    for rule in local.rules : rule.name => rule
  }

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name
}
