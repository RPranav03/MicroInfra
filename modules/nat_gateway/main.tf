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

# Public IP for NAT Gateway
resource "azurerm_public_ip" "nat" {
  count               = var.enable_nat_gateway ? 1 : 0
  name                = "${local.name_prefix}-pip-nat"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-pip-nat"
    }
  )
}

# NAT Gateway
resource "azurerm_nat_gateway" "main" {
  count               = var.enable_nat_gateway ? 1 : 0
  name                = "${local.name_prefix}-nat-gw"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-nat-gw"
    }
  )
}

# Associate NAT Gateway with Public IP
resource "azurerm_nat_gateway_public_ip_association" "main" {
  count                 = var.enable_nat_gateway ? 1 : 0
  nat_gateway_id        = azurerm_nat_gateway.main[0].id
  public_ip_address_id  = azurerm_public_ip.nat[0].id
}

# Associate NAT Gateway with Private Subnets
resource "azurerm_subnet_nat_gateway_association" "private" {
  count           = var.enable_nat_gateway ? length(var.private_subnet_ids) : 0
  subnet_id       = var.private_subnet_ids[count.index]
  nat_gateway_id  = azurerm_nat_gateway.main[0].id
}
