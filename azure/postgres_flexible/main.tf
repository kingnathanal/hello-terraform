resource "azurerm_resource_group" "this" {
  name     = "pgsql-rg2"
  location = "eastus2"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-2"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}
/*
resource "azurerm_private_dns_zone" "this" {
  name                = "pgtest.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.this.name
}
*/
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

resource "azurerm_postgresql_flexible_server" "this" {
  name                   = "pgsql11112023wnb"
  resource_group_name    = azurerm_resource_group.this.name
  location               = azurerm_resource_group.this.location
  version                = "16"
  #delegated_subnet_id    = azapi_resource.subnet1.id
  administrator_login    = "psqladmin"
  administrator_password = "H@Sh1CoR3!"
  #private_dns_zone_id    = azurerm_private_dns_zone.this.id
  storage_mb             = 32768
  zone = 1

  sku_name = "B_Standard_B1ms"
}

resource "azurerm_private_endpoint" "example" {
  name                = "postgresflex-private-endpoint"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = azapi_resource.subnet1.id

  private_service_connection {
    name                           = "postgresflex-privateserviceconnection"
    private_connection_resource_id = azurerm_postgresql_flexible_server.this.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.this.id]
  }
}

data "azurerm_private_dns_zone" "this" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = "hyyercode-rg"
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "pgsql11112023wnb.privatelink"
  resource_group_name   = "hyyercode-rg"
  private_dns_zone_name = data.azurerm_private_dns_zone.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
}