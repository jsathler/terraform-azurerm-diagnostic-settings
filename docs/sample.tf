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
