terraform {
  required_version = "= 1.1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.66.0"
    }
  }
}

provider "azurerm" {
  # common in older enterprise setups to reduce provider auto-registration friction
  skip_provider_registration = true

  features {}
}
