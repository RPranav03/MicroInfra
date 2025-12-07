resource "azurerm_private_endpoint" "main" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.private_endpoint_name}-psc"
    private_connection_resource_id = var.private_connection_resource_id
    subresource_names              = var.subresource_names
    is_manual_connection           = false
  }

  dynamic "private_dns_zone_group" {
    for_each = var.enable_private_dns_zone_group ? [1] : []
    content {
      name                           = "${var.private_endpoint_name}-dns-group"
      private_dns_zone_ids           = var.private_dns_zone_ids
    }
  }

  tags = var.tags

  depends_on = [
    var.depends_on_resources
  ]
}
