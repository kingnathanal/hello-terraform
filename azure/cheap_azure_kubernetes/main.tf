resource "azurerm_kubernetes_cluster" "this" {
  name                      = "cheap-aks"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  dns_prefix                = "cheapaks"
  node_resource_group       = "${var.resource_group_name}-managed"
  sku_tier                  = "Free"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true


  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "basic"
  }

  default_node_pool {
    name           = "kubepool"
    node_count     = 1
    vm_size        = "Standard_B2als_v2" // Standard_B2s - use when no quota
    vnet_subnet_id = var.vnet_subnet_id
    os_sku         = "Ubuntu"
  }

  identity {
    type = "SystemAssigned"
  }
}