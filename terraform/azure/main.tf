locals {
  location = "eastus"
  tags = {
    owner = "Will Britton"
    managed_by = "Terraform"
  }
}

// create a resource group
resource "azurerm_resource_group" "this" {
  name     = "hyyercode-rg-terraform"
  location = local.location
  tags = local.tags
}

// create a postgresql server
resource "azurerm_postgresql_server" "this" {
  name                = "hyyercode-pg-terraform"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "B_Gen5_1"
  storage_mb          = 5120
  version             = "9.6"
  administrator_login = "hyyercode"
  administrator_login_password = "hyyercode"
  ssl_enforcement_enabled = true
  tags = local.tags
}