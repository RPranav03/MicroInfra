terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
  resource_group_name  = "a1-rg1"
  storage_account_name = "stgpr872133"
  container_name       = "tfstate"
  key                  = "dev/terraform.tfstate"
}

}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id

}

