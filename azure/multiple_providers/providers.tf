terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.81.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias = "second"
  subscription_id = "ca8d284a-c1ea-493c-873d-ac8b31b6616e"
}