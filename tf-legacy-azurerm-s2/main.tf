
terraform {
  required_version = ">= 1.1.3"

  #Declare AzureRM Provider version constraint
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.116.0"
    }
  }

  #Declare Remote Backend on Storage Account's container
  backend "local" {
  }
}

provider "azurerm" {
  features {}
  subscription_id            = "db9d0627-cb52-4e79-8c04-49813cfdbed1" # Non-Production
  skip_provider_registration = true
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "southeastasia"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestorageacc"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "example" {
  name               = "example"
  storage_account_id = azurerm_storage_account.example.id
}

#Block attribute deprecation to another named block attribute
resource "azurerm_synapse_workspace" "example" {
  name                                 = "example"
  resource_group_name                  = azurerm_resource_group.example.name
  location                             = azurerm_resource_group.example.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.example.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "H@Sh1CoR3!"

  #Static block for a deprecating attributes
  sql_aad_admin {
    login     = "AzureAD Admin"
    object_id = "00000000-0000-0000-0000-000000000000"
    tenant_id = "00000000-0000-0000-0000-000000000000"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Env = "production"
  }
}

#Dynamic block attribute deprecation to another named block attribute
resource "azurerm_synapse_workspace" "example2" {
  name                                 = "example2"
  resource_group_name                  = azurerm_resource_group.example.name
  location                             = azurerm_resource_group.example.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.example.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "H@Sh1CoR3!"

  #Dynamic blocks for a deprecating attributes
  dynamic "sql_aad_admin" {
    for_each = [1]
    content {
      login     = "AzureAD Admin"
      object_id = "00000000-0000-0000-0000-000000000000"
      tenant_id = "00000000-0000-0000-0000-000000000000"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Env = "production"
  }
}


#Block attribute deprecation to a new resource type
resource "azurerm_api_management" "example" {
  name                = "example-apim"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  publisher_name      = "My Company"
  publisher_email     = "company@terraform.io"

  sku_name = "Developer_1"

  #Deprecating attribute
  policy {
    xml_content = "TEST"
  }
}

#Dynamic block attribute deprecation to a new resource type
resource "azurerm_api_management" "example2" {
  name                = "example-apim"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  publisher_name      = "My Company"
  publisher_email     = "company@terraform.io"

  sku_name = "Developer_1"

  #Deprecating dynamic attribute
  dynamic "policy" {
    for_each = [1]
    content {
      xml_content = "TEST"
    }
  }
}

resource "azurerm_api_management_policy" "example" {
  api_management_id = azurerm_api_management.example.id
  xml_content       = file("example.xml")
}