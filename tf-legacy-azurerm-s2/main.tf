
terraform {
  required_version = ">= 1.14.1"

  #Declare AzureRM Provider version constraint
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.55.0"
    }
  }

  #Declare Remote Backend on Storage Account's container
  backend "local" {
  }
}

provider "azurerm" {
  features {}
  subscription_id            = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  resource_provider_registrations = "none"
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "southeastasia"
}

data "azurerm_client_config" "current" {}

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
}

#Dynamic block attribute deprecation to a new resource type
resource "azurerm_api_management" "example2" {
  name                = "example-apim"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  publisher_name      = "My Company"
  publisher_email     = "company@terraform.io"

  sku_name = "Developer_1"
}

resource "azurerm_api_management_policy" "example" {
  api_management_id = azurerm_api_management.example.id
  xml_content       = <<EOF
<policies>
  <inbound>
    <base />
  </inbound>
  <outbound>
    <base />
  </outbound>
</policies>
EOF
}

# Added new resource for Synapse Workspace AAD admin (replaces deprecated sql_aad_admin block)
resource "azurerm_synapse_workspace_sql_aad_admin" "example" {
  synapse_workspace_id = azurerm_synapse_workspace.example.id
  login                = "AzureAD Admin"
  object_id            = data.azurerm_client_config.current.object_id
  tenant_id            = data.azurerm_client_config.current.tenant_id
}

# Added new resource for Synapse Workspace AAD admin (replaces deprecated sql_aad_admin block)
resource "azurerm_synapse_workspace_sql_aad_admin" "example2" {
  synapse_workspace_id = azurerm_synapse_workspace.example2.id
  login                = "AzureAD Admin"
  object_id            = data.azurerm_client_config.current.object_id
  tenant_id            = data.azurerm_client_config.current.tenant_id
}
