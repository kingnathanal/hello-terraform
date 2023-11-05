variable "resource_group_name" {
  description = "The name of the resource group in which to create the AKS cluster."
  type        = string
}

variable "location" {
  description = "The Azure Region in which to create the AKS cluster."
  type        = string
}

variable "vnet_subnet_id" {
  description = "The ID of the subnet in which to deploy the AKS cluster."
  type        = string
  default     = null
}

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
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "basic"
    service_cidr      = "172.25.0.0/16"
    dns_service_ip    = "172.25.0.10"
  }

  default_node_pool {
    name           = "kubepool"
    node_count     = 1
    vm_size        = "Standard_B2s"
    vnet_subnet_id = var.vnet_subnet_id
    os_sku         = "Ubuntu"
  }

  identity {
    type = "SystemAssigned"
  }
}