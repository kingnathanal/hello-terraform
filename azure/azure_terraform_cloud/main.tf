locals {
  location = "eastus2"
  tags = {
    owner      = "Will Britton"
    managed_by = "Terraform"
  }
}

// create a resource group
resource "azurerm_resource_group" "this" {
  name     = "hyyercode-rg-terraform-01"
  location = local.location
  tags     = local.tags
}