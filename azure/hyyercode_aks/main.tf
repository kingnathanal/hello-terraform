locals {
  location = "eastus"
  tags = {
    owner      = "Will Britton"
    managed_by = "Terraform"
  }
}

resource "azurerm_resource_group" "this" {
  name     = "hyyercode-rg-aks"
  location = local.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "this" {
  name                = "hyyercode-aks-vnet"
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

resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "hyyercode-aks-identity"
  resource_group_name = azurerm_resource_group.this.name
  location            = local.location
}

module "cheap_azure_kubernetes" {
  source  = "app.terraform.io/hyyercode/cheap_aks/azurerm"
  version = "1.1.2"
  #source              = "./cheap_azure_kubernetes"
  resource_group_name = azurerm_resource_group.this.name
  location            = local.location
  vnet_subnet_id      = azurerm_subnet.aks_subnet.id
  aks_name            = "hyyercode-aks"
  aks_dns_prefix      = "hyyercode"
  aks_sku             = "Standard_A2_v2"
  identity = {
    type: "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aks_identity.id
    ]
  }
}