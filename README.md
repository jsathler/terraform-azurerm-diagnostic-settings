<!-- BEGIN_TF_DOCS -->
# Azure Diagnostic Settings module

Terraform module which enables Azure Diagnostic Settings on Azure resources.

Supported Azure services:

* [Azure diagnostic settings](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.70.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.70.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_categories.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_destination"></a> [destination](#input\_destination) | . This parameter is required<br>   - storage\_account\_id:              (optional) The ID of the Storage Account where logs should be sent<br>   - eventhub\_name:                   (optional) Specifies the name of the Event Hub where Diagnostics Data should be sent. Requires "eventhub\_authorization\_rule\_id"<br>   - eventhub\_authorization\_rule\_id:  (optional) Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data<br>   - log\_analytics\_workspace\_id:      (optional) Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent<br>   - log\_analytics\_destination\_type:  (optional) Possible values are AzureDiagnostics and Dedicated. Defaults to null (Azure API defaults to "AzureDiagnostics")<br>   - partner\_solution\_id:             (optional) The ID of the market partner solution where Diagnostics Data should be sent. | <pre>object({<br>    storage_account_id             = optional(string, null)<br>    eventhub_name                  = optional(string, null)<br>    eventhub_authorization_rule_id = optional(string, null)<br>    log_analytics_workspace_id     = optional(string, null)<br>    log_analytics_destination_type = optional(string, null)<br>    partner_solution_id            = optional(string, null)<br>  })</pre> | n/a | yes |
| <a name="input_logs"></a> [logs](#input\_logs) | Logs categories. This parameter is optional but you should provide "logs" and/or "metrics"<br>  - categories:     (optional) A list of Diagnostic Log Categories. Defaults to []<br>  - all\_available:  (optional) If set to true, all available logs will be enabled. Defaults to false<br>  - all\_exceptions: (optional) A list of Diagnostic Log Categories you want to except from the "all" list. Defaults to [] | <pre>object({<br>    all_available  = optional(bool, false)<br>    all_exceptions = optional(list(string), [])<br>    categories     = optional(list(string), [])<br>  })</pre> | `{}` | no |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | The name of a Diagnostic Metric Category for this Resource. This parameter is optional but you should provide "metrics" and/or "logs" | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Specifies the name of the Diagnostic Setting. This parameter is required | `string` | n/a | yes |
| <a name="input_resource_id"></a> [resource\_id](#input\_resource\_id) | The ID of an existing Resource on which to configure Diagnostic Settings. This parameter is required | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Diagnostic Settings ID |
| <a name="output_name"></a> [name](#output\_name) | Diagnostic Settings name |

## Examples
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
More examples in ./examples folder
<!-- END_TF_DOCS -->