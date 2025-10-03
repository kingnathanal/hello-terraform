resource "azurerm_kubernetes_cluster" "this" {
  name                      = var.aks_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  dns_prefix                = var.aks_dns_prefix
  node_resource_group       = "${var.resource_group_name}-managed"
  sku_tier                  = "Free"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  network_profile {
    network_plugin    = "azure"
    network_plugin_mode = "overlay"
  }

  default_node_pool {
    name           = "karpenterpool"
    node_count     = 1
    vm_size        = var.aks_sku
    vnet_subnet_id = var.vnet_subnet_id
    os_sku         = "Ubuntu"
    temporary_name_for_rotation = "karpenterpooltemp"
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
    tenant_id = data.azurerm_subscription.current.tenant_id
  }

  dynamic "kubelet_identity" {

    for_each = var.msi_identity == null ? [] : ["enabled"]
    content {
      client_id                 = var.msi_identity.client_id
      object_id                 = var.msi_identity.principal_id
      user_assigned_identity_id = var.msi_identity.user_assigned_id
    }
  }

  dynamic "identity" {
    for_each = var.identity == null ? [] : ["enabled"]
    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [] : ["enabled"]
    content {
      type = "SystemAssigned"
    }
  }
}