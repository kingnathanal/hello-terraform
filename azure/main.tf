locals {
  location = var.region
  tags = {
    owner      = "Will Britton"
    managed_by = "Terraform"
  }
}

variable "region" {
  description = "The region in which all resources will be created"
  type        = string
}

variable "subscription_id" {
  description = "The subscription ID to use for the resources"
  type        = string
}

variable "secondary_subscription_id" {
  description = "The subscription ID to use for the resources"
  type        = string
  default     = ""
}

// create a resource group
resource "azurerm_resource_group" "this" {
  name     = "hyyercode-rg-terraform"
  location = local.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "this" {
  name                = "hyyercode-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = local.location
  resource_group_name = azurerm_resource_group.this.name
}



resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_subnet" "app_subnet" {
  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.1.1.0/24"]
}
/*
module "cheap_azure_kubernetes" {
  source  = "app.terraform.io/hyyercode/cheap_aks/azurerm"
  version = "1.0.0"
  #source              = "./cheap_azure_kubernetes"
  resource_group_name = azurerm_resource_group.this.name
  location            = local.location
  vnet_subnet_id      = azurerm_subnet.aks_subnet.id
}
*/

variable "prevent_destroy" {
  description = "Prevent the destruction of the resource"
  type        = bool
  default     = false
}

resource "azurerm_storage_account" "this" {
  name                     = "hyyercodestorage"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

output "resource_group_id" {
  value = azurerm_resource_group.this.id
}

output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks_subnet.id
}

output "app_subnet_id" {
  value     = azurerm_subnet.app_subnet.id
  sensitive = true
}