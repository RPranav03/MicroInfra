output "firewall_rule_ids" {
  description = "Firewall rule IDs"
  value       = {
    for name, rule in azurerm_mysql_firewall_rule.main : name => rule.id
  }
}
