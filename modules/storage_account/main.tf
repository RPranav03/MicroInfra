resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  
  https_traffic_only_enabled       = true
  min_tls_version                  = "TLS1_2"
  shared_access_key_enabled        = var.shared_access_key_enabled
  default_to_oauth_authentication = true
  
  network_rules {
    default_action             = var.network_default_action
    bypass                     = var.network_bypass
    virtual_network_subnet_ids = var.allowed_subnet_ids
    ip_rules                   = var.allowed_ip_addresses
  }

  blob_properties {
    change_feed_enabled           = true
    change_feed_retention_in_days = var.change_feed_retention_days
    versioning_enabled            = true
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Blob container for application data
resource "azurerm_storage_container" "app_data" {
  count                 = var.create_blob_containers ? 1 : 0
  name                  = "${var.storage_account_name}-app-data"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Blob container for backups
resource "azurerm_storage_container" "backups" {
  count                 = var.create_blob_containers ? 1 : 0
  name                  = "${var.storage_account_name}-backups"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Blob container for logs
resource "azurerm_storage_container" "logs" {
  count                 = var.create_blob_containers ? 1 : 0
  name                  = "${var.storage_account_name}-logs"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Lifecycle policy for automatic data archival
resource "azurerm_storage_management_policy" "archive" {
  count              = var.enable_lifecycle_management ? 1 : 0
  storage_account_id = azurerm_storage_account.main.id

  rule {
    name    = "ArchiveOldData"
    enabled = true
    
    filters {
      prefix_match = ["data/"]
      blob_types   = ["blockBlob"]
    }

    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than   = 30
        tier_to_archive_after_days_since_modification_greater_than = 90
        delete_after_days_since_modification_greater_than          = 365
      }
      snapshot {
        delete_after_days_since_creation_greater_than = 30
      }
      version {
        delete_after_days_since_creation = 90
      }
    }
  }
}

# Private endpoint for secure blob access
resource "azurerm_private_endpoint" "blob" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "${var.storage_account_name}-blob-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.storage_account_name}-blob-psc"
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  tags = var.tags
}
