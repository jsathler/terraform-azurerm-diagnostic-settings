/*
  References:
    https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
    https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/azurediagnostics#resource-types
    https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/resource-logs
    https://github.com/claranet/terraform-azurerm-diagnostic-settings/

  Deprecated: 
    retention_policy block: https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/migrate-to-azure-storage-lifecycle-policy
*/

# Get available categories and metrics for specified resource type
data "azurerm_monitor_diagnostic_categories" "default" {
  resource_id = var.resource_id
}

locals {
  /*
    If var.logs.categories is not provided, it will enable all available logs that is not in the exception list
  */

  log_categories = [for category in
    (var.logs.all_available == false ? var.logs.categories : try(data.azurerm_monitor_diagnostic_categories.default.log_category_types, []))
    : category if !contains(var.logs.all_exceptions, category)
  ]
}

resource "azurerm_monitor_diagnostic_setting" "default" {
  name               = var.name
  target_resource_id = var.resource_id

  #Destinations
  storage_account_id             = var.destination.storage_account_id
  eventhub_name                  = var.destination.eventhub_name
  eventhub_authorization_rule_id = var.destination.eventhub_authorization_rule_id
  log_analytics_workspace_id     = var.destination.log_analytics_workspace_id
  log_analytics_destination_type = var.destination.log_analytics_destination_type
  partner_solution_id            = var.destination.partner_solution_id

  dynamic "enabled_log" {
    for_each = [for category in local.log_categories : category]
    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    #for_each = { for key, value in var.metrics : key => value }
    for_each = var.metrics
    content {
      category = enabled_metric.value
    }
  }
}
