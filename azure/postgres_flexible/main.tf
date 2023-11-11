resource "azurerm_resource_group" "this" {
  name     = "pgsql-rg"
  location = "eastus2"
  tags     = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone" "this" {
  name                = "pgtest.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_route_table" "this" {
  name = "subnet-rt"
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azapi_resource" "subnet1" {
  type = "Microsoft.Network/virtualNetworks/subnets@2023-05-01"
  name = "subnet1"
  parent_id = azurerm_virtual_network.this.id
  body = jsonencode({
      properties = {
        addressPrefix = "10.1.0.0/24"
        routeTable = {
          id = azurerm_route_table.this.id
        }
        delegations = [
          {
            name : "post-delegation"
            properties : {
              "serviceName" : "Microsoft.DBforPostgreSQL/flexibleServers"
            }
          }
        ]
        privateEndpointNetworkPolicies = "Enabled"
        privateLinkServiceNetworkPolicies = "Enabled"
      }
  })
}

resource "azurerm_postgresql_flexible_server" "example" {
  name                   = "pgsql-flexible-11112023-server"
  resource_group_name    = azurerm_resource_group.this.name
  location               = azurerm_resource_group.this.location
  version                = "14"
  delegated_subnet_id    = azapi_resource.subnet1.id
  administrator_login    = "psqladmin"
  administrator_password = "H@Sh1CoR3!"
  private_dns_zone_id    = azurerm_private_dns_zone.this.id
  storage_mb = 32768

  sku_name   = "B_Standard_B1ms"
}