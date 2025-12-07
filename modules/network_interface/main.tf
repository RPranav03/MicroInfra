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

# Network Interfaces
resource "azurerm_network_interface" "main" {
  count               = var.nic_count
  name                = "${local.name_prefix}-nic-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "testConfiguration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.assign_public_ip ? var.public_ip_ids[count.index] : null
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-nic-${count.index + 1}"
    }
  )
}
