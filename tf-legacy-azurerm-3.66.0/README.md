# Legacy Terraform sample (Terraform 1.1.3 + AzureRM 3.66.0)

This is intentionally **legacy / older-style** AzureRM code designed to be a good target for a “tech refresh” agent.
It pins:
- Terraform `= 1.1.3`
- Provider `hashicorp/azurerm = 3.66.0`

## What’s “legacy” here (on purpose)
- Uses **`azurerm_virtual_machine`** (older VM resource) instead of `azurerm_linux_virtual_machine`.
- Uses **`azurerm_app_service`** (older App Service resource) instead of `azurerm_linux_web_app`.
- A few older patterns/fields that commonly require review when upgrading provider major versions.

> Note: applying this requires Azure credentials. It’s mainly meant for validation/upgrade testing.

## Quick test
```bash
terraform -version   # should be 1.1.3
terraform init
terraform validate
```
