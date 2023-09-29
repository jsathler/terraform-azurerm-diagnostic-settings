output "id" {
  description = "Diagnostic Settings ID"
  value       = azurerm_monitor_diagnostic_setting.default.id
}

output "name" {
  description = "Diagnostic Settings name"
  value       = azurerm_monitor_diagnostic_setting.default.name
}
