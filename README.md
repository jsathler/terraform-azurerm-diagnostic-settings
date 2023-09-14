# Azure Diagnostic Settings module

Terraform module which enables Azure Diagnostic Settings on Azure resources.

These types of resources are supported:

* [Azure diagnostic settings](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings)

## Terraform versions

Terraform 1.5.6 and newer.

## Usage

```hcl
module "nsg-log" {
  source      = "jsathler/diagnostic-settings/azurerm"
  name        = "default-logging"
  resource_id = azurerm_network_security_group.default.id

  destination = {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id
  }

  logs = {
    all_available  = true
    all_exceptions = ["NetworkSecurityGroupEvent"]
  }
}
```

More samples in examples folder