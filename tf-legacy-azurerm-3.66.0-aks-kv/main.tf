data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "${var.name_prefix}-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name_prefix}-vnet"
  address_space       = ["10.60.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_subnet" "aks" {
  name                 = "${var.name_prefix}-aks-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.60.1.0/24"]
}

# Log Analytics workspace for OMS agent addon (legacy AKS addon_profile usage)
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.name_prefix}-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# -----------------------
# Key Vault (legacy inline access_policy)
# -----------------------
resource "azurerm_key_vault" "kv" {
  name                       = "${replace(var.name_prefix, "-", "")}kv${substr(sha1(azurerm_resource_group.rg.id), 0, 6)}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  tags                       = var.tags

  # Legacy-style access policy block (common upgrade target to RBAC-based authorization)
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
    ]
  }
}

resource "azurerm_key_vault_secret" "example" {
  name         = "example-secret"
  value        = "replace-me"
  key_vault_id = azurerm_key_vault.kv.id
}

# -----------------------
# AKS (legacy patterns for upgrade testing)
# -----------------------
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.name_prefix}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.name_prefix}-dns"
  tags                = var.tags

  # Older pattern: Service Principal authentication (often migrated to Managed Identity)
  service_principal {
    client_id     = var.sp_client_id
    client_secret = var.sp_client_secret
  }

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_B2s"
    vnet_subnet_id  = azurerm_subnet.aks.id
    max_pods        = 30
    os_disk_size_gb = 30
  }

  # Legacy-ish block locations/names are good upgrade targets
  role_based_access_control {
    enabled = true
  }

  # Older addon_profile style (fields may change/remove across major versions)
  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
    }

    # Historically common legacy addon - may be removed/renamed in newer provider versions
    kube_dashboard {
      enabled = false
    }
  }

  network_profile {
    network_plugin = "kubenet"
    dns_service_ip = "10.2.0.10"
    service_cidr   = "10.2.0.0/24"
  }
}
