# Firewall rules
resource "azurerm_mysql_firewall_rule" "main" {
  for_each = {
    for rule in var.firewall_rules : rule.name => rule
  }

  name                = each.value.name
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = each.value.start_ip_address
  end_ip_address      = each.value.end_ip_address
}
