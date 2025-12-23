
terraform {
  required_version = ">= 1.14.0, < 2.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.57.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.12.0"
    }
  }
}

# Provider configuration blocks
provider "azurerm" {
  subscription_id = "173a7596-6007-42f3-829e-e0d127b88a49"

  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}

