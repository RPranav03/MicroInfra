locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(
    {
      Name        = local.name_prefix
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

# Public IPs
resource "azurerm_public_ip" "main" {
  count               = var.ip_count
  name                = "${local.name_prefix}-pip-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.allocation_method
  sku                 = var.sku

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-pip-${count.index + 1}"
    }
  )
}
