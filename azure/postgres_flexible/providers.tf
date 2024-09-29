terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "1.12.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "azapi" {
  subscription_id = var.subscription_id
}

variable "subscription_id" {
  description = "The subscription ID to use for the resources"
  type        = string
}