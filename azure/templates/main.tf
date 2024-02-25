locals {
  location = var.azure_region
  tags = {
    owner      = "Will Britton"
    managed_by = "Terraform"
  }
}

// create a resource group
resource "azurerm_resource_group" "this" {
  name     = "hyyercode-rg-terraform-${var.azure_region}"
  location = local.location
  tags     = local.tags
}