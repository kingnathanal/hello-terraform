locals {
  tags = {
    owner      = "Will Britton"
    managed_by = "Terraform"
  }
}

resource "azurerm_resource_group" "this" {
  name     = "terraform-rg-stacks"
  location = var.region
  tags     = local.tags
}

variable "region" {
  description = "The region in which all resources will be created"
  type        = string
}

output "resource_group_name" {
  value = azurerm_resource_group.this.name
}