// Running 2 subnets in parallel using azapi_resource returns
/*

 --------------------------------------------------------------------------------
│ RESPONSE 409: 409 Conflict
│ ERROR CODE: AnotherOperationInProgress
│ --------------------------------------------------------------------------------
│ {
│   "error": {
│     "code": "AnotherOperationInProgress",
│     "message": "Another operation on this or dependent resource is in progress. To retrieve status of the operation use uri: https://management.azure.com/subscriptions/cba339b6-ea03-48de-912f-7213c3f451ae/providers/Microsoft.Network/locations/eastus2/operations/439c7509-2b5f-44ff-bb7f-762324d7f275?api-version=2022-07-01.",
│     "details": []
│   }
│ }
│ --------------------------------------------------------------------------------


*/

resource "azurerm_resource_group" "this" {
  name     = "parallel_subnet"
  location = "eastus2"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-wb-parallel-subnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_route_table" "this" {
  name                = "subnet-rt"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azapi_resource" "subnet1" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2023-05-01"
  name      = "subnet1"
  parent_id = azurerm_virtual_network.this.id
  body = jsonencode({
    properties = {
      addressPrefix = "10.1.0.0/24"
      routeTable = {
        id = azurerm_route_table.this.id
      }
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
    }
  })
}

resource "azapi_resource" "subnet2" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2023-05-01"
  name      = "subnet2"
  parent_id = azurerm_virtual_network.this.id
  body = jsonencode({
    properties = {
      addressPrefix = "10.1.1.0/24"
      routeTable = {
        id = azurerm_route_table.this.id
      }
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
    }
  })
}


