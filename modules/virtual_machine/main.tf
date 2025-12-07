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

# Virtual Machines
resource "azurerm_virtual_machine" "main" {
  count                 = var.vm_count
  name                  = "${local.name_prefix}-vm-${count.index + 1}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [var.nic_ids[count.index]]
  vm_size               = var.vm_size

  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  storage_os_disk {
    name              = "${local.name_prefix}-osdisk-${count.index + 1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.os_disk_type
    disk_size_gb      = var.os_disk_size_gb
  }

  os_profile {
    computer_name  = "${local.name_prefix}-vm-${count.index + 1}"
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = var.disable_password_authentication

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = ""
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-vm-${count.index + 1}"
    }
  )
}
