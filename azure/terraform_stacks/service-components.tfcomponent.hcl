variable "azure_region" {
  type        = string
  description = "The Azure region to deploy resources in."
}

component "bootstrap" {
  source = "./bootstrap"
  inputs = {
    region = var.azure_region
  }
  providers = {
    azurerm = provider.azurerm.this
  }
}

component "vnet" {
  source = "./vnet"
  inputs = {
    region              = var.azure_region
    resource_group_name = component.bootstrap.resource_group_name
  }
  providers = {
    azurerm = provider.azurerm.this
  }
}