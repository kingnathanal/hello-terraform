required_providers {
  azurerm = {
    source  = "hashicorp/azurerm"
    version = "4.47.0"
  }
  azapi = {
    source  = "azure/azapi"
    version = "2.7.0"
  }
}

provider "azurerm" "this" {
  config {
    features {}

    use_cli = false

    //use_oidc        = true
    //oidc_token      = var.identity_token
    client_id       = var.client_id
    subscription_id = var.subscription_id
    tenant_id       = var.tenant_id
    client_secret   = var.client_secret
  }
}

provider "azapi" "this" {
  config {
    //use_oidc        = true
    //oidc_token      = var.identity_token
    client_id       = var.client_id
    subscription_id = var.subscription_id
    tenant_id       = var.tenant_id
    client_secret   = var.client_secret
  }
}

variable "client_id" {
  type        = string
  description = "The Client ID of the Service Principal to use for authentication."
  ephemeral   = true
  sensitive = true
}

variable "subscription_id" {
  type        = string
  description = "The Subscription ID to use for authentication."
}

variable "tenant_id" {
  type        = string
  description = "The Tenant ID of the Service Principal to use for authentication."
  ephemeral   = true
  sensitive   = true
}

variable "identity_token" {
  type        = string
  description = "The OIDC identity token to use for authentication."
  ephemeral   = true
  default     = ""
}

variable "client_secret" {
  type        = string
  description = "The Client Secret of the Service Principal to use for authentication."
  ephemeral   = true
  sensitive   = true
}