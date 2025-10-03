resource "azurerm_virtual_network" "this" {
  name                = "hyyercode-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = var.region
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_subnet" "app_subnet" {
  name                 = "app-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.1.1.0/24"]
}

variable "resource_group_name" {
  description = "The name of the resource group in which all resources will be created"
  type        = string
}

variable "region" {
  description = "The region in which all resources will be created"
  type        = string
}