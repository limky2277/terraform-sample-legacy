# Legacy/upgrade-stress Terraform sample (Terraform 1.1.3 + AzureRM 3.66.0)

This sample is intentionally written in **older AzureRM patterns** that tend to require extra work when upgrading
to newer major versions (AzureRM 4.x / 5.x), making it a good target for Cline + Terraform KB MCP tests.

Pinned versions:
- Terraform: `= 1.1.3`
- Provider: `hashicorp/azurerm = 3.66.0`

## “Upgrade pain” patterns included (on purpose)
1. **AKS uses a Service Principal (`service_principal { ... }`)**
   - Newer best practice is usually Managed Identity (`identity { type = "SystemAssigned" }`) and updated RBAC blocks.
2. **AKS uses legacy-style `addon_profile`** (e.g. OMS agent / kube dashboard patterns)
   - Some addons/blocks get renamed, moved, or removed across major versions.
3. **Key Vault uses inline `access_policy { ... }`**
   - Newer setups often move toward RBAC-based Key Vault authorization.

> Applying this requires valid Azure credentials + a real Service Principal (Client ID/Secret), but it’s primarily
meant for *upgrade analysis* and *code transformation testing*.

## Quick test
```bash
terraform -version   # should be 1.1.3
terraform init
terraform validate
```

## Inputs you’ll likely set
- `TF_VAR_sp_client_id`
- `TF_VAR_sp_client_secret`
- (optional) `TF_VAR_location`
