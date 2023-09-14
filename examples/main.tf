provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "logging-example-rg"
  location = "northeurope"
}

resource "azurerm_log_analytics_workspace" "default" {
  name                = "logging-log"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

resource "random_string" "default" {
  length    = 6
  min_lower = 6
}

#Creating SA and Analytics to send logs
resource "azurerm_storage_account" "default" {
  name                     = "logging${random_string.default.result}sa"
  location                 = azurerm_resource_group.default.location
  resource_group_name      = azurerm_resource_group.default.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_network_security_group" "default" {
  name                = "logging-nsg"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

#Creating resources to enable diagnostic logging
resource "azurerm_public_ip" "default" {
  name                = "logging-pip"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  allocation_method   = "Static"
}

resource "azurerm_virtual_network" "default" {
  name                = "logging-vnet"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/16"]
}

#All categories but NetworkSecurityGroupEvent with Log Analytics as destination
module "nsg-log" {
  source      = "../"
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

#All metrics and all categories with Storage Account as destination
module "vnet-log" {
  source      = "../"
  name        = "default-logging"
  resource_id = azurerm_virtual_network.default.id

  destination = {
    storage_account_id = azurerm_storage_account.default.id
  }

  logs = {
    all_available = true
  }
  metrics = ["AllMetrics"]
}

# Only categories DDoSMitigationFlowLogs and DDoSMitigationReports with Log Analytics as destination
module "pip-log" {
  source      = "../"
  name        = "categories-logging"
  resource_id = azurerm_public_ip.default.id

  destination = {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id
  }

  logs = {
    categories = ["DDoSMitigationFlowLogs", "DDoSMitigationReports"]
  }
}

# Only metrics with Storage Account as destination
module "pip2-log" {
  source      = "../"
  name        = "metrics-logging"
  resource_id = azurerm_public_ip.default.id

  destination = {
    storage_account_id = azurerm_storage_account.default.id
  }

  metrics = ["AllMetrics"]
}

output "vnet-log" {
  value = module.vnet-log
}

output "nsg-log" {
  value = module.nsg-log
}

output "pip-log" {
  value = module.pip-log
}

output "pip2-log" {
  value = module.pip2-log
}
