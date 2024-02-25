/*
  References:
  https://github.com/Azure-Samples/aks-managed-prometheus-and-grafana-bicep
*/

locals {
  project_name = "aks_prom_stack"
  location     = "eastus2"
  tags = {
    owner      = "Will Britton"
    managed_by = "Terraform"
  }
}

// create a resource group
resource "azurerm_resource_group" "this" {
  name     = "aks_grafana_stack-rg-terraform"
  location = local.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "this" {
  name                = "aksvnet"
  address_space       = ["10.0.0.0/8"]
  location            = local.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "azurebastion-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.243.2.0/24"]
}

resource "azurerm_subnet" "pe_subnet" {
  name                 = "pe-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.243.1.0/24"]
}

resource "azurerm_subnet" "aks_api_server_subnet" {
  name                 = "aks-api-server-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.243.0.0/27"]
}

resource "azurerm_subnet" "aks_system_subnet" {
  name                 = "aks-system-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.240.0.0/16"]
}

resource "azurerm_subnet" "aks_user_subnet" {
  name                 = "aks-user-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.244.0.0/16"]
}

resource "azurerm_subnet" "aks_windows_subnet" {
  name                 = "aks-user-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.241.0.0/16"]
}

resource "azurerm_subnet" "aks_pod_subnet" {
  name                 = "aks-pod-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.242.0.0/16"]
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "aks"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  default_node_pool {
    name           = "system"
    node_count     = 1
    vm_size        = "Standard_B2als_v2"
    vnet_subnet_id = azurerm_subnet.aks_system_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

resource "azurerm_monitor_workspace" "this" {
  name                = "monitor-workspace"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = local.tags
}

resource "azurerm_monitor_data_collection_endpoint" "example" {
  name                          = "example-mdce"
  resource_group_name           = azurerm_resource_group.example.name
  location                      = azurerm_resource_group.example.location
  kind                          = "Windows"
  public_network_access_enabled = true
  description                   = "monitor_data_collection_endpoint example"
  tags = {
    foo = "bar"
  }
}

// create azure keyvault
resource "azurerm_key_vault" "this" {
  name                        = "keyvault"
  location                    = azurerm_resource_group.this.location
  resource_group_name         = azurerm_resource_group.this.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled    = false
  enabled_for_disk_encryption = true
  tags = local.tags
}