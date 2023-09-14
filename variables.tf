variable "name" {
  description = "Specifies the name of the Diagnostic Setting. This parameter is required"
  type        = string
  nullable    = false
}

variable "resource_id" {
  description = "The ID of an existing Resource on which to configure Diagnostic Settings. This parameter is required"
  type        = string
  nullable    = false
}

variable "destination" {
  description = <<DESCRIPTION
  . This parameter is required
   - storage_account_id:              (optional) The ID of the Storage Account where logs should be sent
   - eventhub_name:                   (optional) Specifies the name of the Event Hub where Diagnostics Data should be sent. Requires "eventhub_authorization_rule_id"
   - eventhub_authorization_rule_id:  (optional) Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data
   - log_analytics_workspace_id:      (optional) Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent
   - log_analytics_destination_type:  (optional) Possible values are AzureDiagnostics and Dedicated. Defaults to null (Azure API defaults to "AzureDiagnostics")
   - partner_solution_id:             (optional) The ID of the market partner solution where Diagnostics Data should be sent.
  DESCRIPTION
  type = object({
    storage_account_id             = optional(string, null)
    eventhub_name                  = optional(string, null)
    eventhub_authorization_rule_id = optional(string, null)
    log_analytics_workspace_id     = optional(string, null)
    log_analytics_destination_type = optional(string, null)
    partner_solution_id            = optional(string, null)
  })
  nullable = false

  validation {
    condition     = alltrue([var.destination.storage_account_id != null || var.destination.eventhub_authorization_rule_id != null || var.destination.log_analytics_workspace_id != null || var.destination.partner_solution_id != null])
    error_message = "storage_account_id, eventhub_authorization_rule_id, log_analytics_workspace_id partner_solution_id groups is required"
  }
}

variable "logs" {
  description = <<DESCRIPTION
  Logs categories. This parameter is optional but you should provide "logs" and/or "metrics"
  - categories:     (optional) A list of Diagnostic Log Categories. Defaults to []
  - all_available:  (optional) If set to true, all available logs will be enabled. Defaults to false
  - all_exceptions: (optional) A list of Diagnostic Log Categories you want to except from the "all" list. Defaults to []
  DESCRIPTION

  type = object({
    all_available  = optional(bool, false)
    all_exceptions = optional(list(string), [])
    categories     = optional(list(string), [])
  })
  default  = {}
  nullable = false
}

variable "metrics" {
  description = " The name of a Diagnostic Metric Category for this Resource. This parameter is optional but you should provide \"metrics\" and/or \"logs\""
  type        = list(string)
  default     = []
  nullable    = false
}
