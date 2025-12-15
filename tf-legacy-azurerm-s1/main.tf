
terraform {
  required_version = ">= 1.1.3"

  #Declare AzureRM Provider version constraint
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.66.0"
    }
  }

  #Declare Remote Backend on Storage Account's container
  backend "local" {
  }
}

provider "azurerm" {
  features {}
  subscription_id            = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  skip_provider_registration = true
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "southeastasia"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  enable_ip_forwarding = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}
