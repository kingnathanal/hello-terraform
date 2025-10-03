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

variable "aks_sku" {
  description = "The SKU of the AKS cluster."
  type        = string
  default     = "Standard_B2als_v2"
}

variable "aks_name" {
  description = "The name of the AKS cluster."
  type        = string
  default     = "cheap-aks"
}

variable "aks_dns_prefix" {
  description = "The DNS prefix to use with the AKS cluster."
  type        = string
  default     = "cheapaks"
}

variable "identity" {
  description = "The identity to assign to the AKS cluster."
  type = object(
    {
      type         = string
      identity_ids = list(string)
    }
  )
  default = null
}

variable "msi_identity" {
  description = "The identity to assign to the AKS cluster."
  type = object(
    {
      client_id        = string
      principal_id     = string
      user_assigned_id = string
    }
  )
  default = null
}

variable "subscription_id" {
  type = string
  description = "value of the subscription id"
}