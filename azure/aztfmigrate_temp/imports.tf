
provider "azurerm" {
  features {}
  subscription_id = "cba339b6-ea03-48de-912f-7213c3f451ae"
}

provider "azapi" {
}
terraform {
  backend "azurerm" {
    resource_group_name  = "hyyercode-rg"
    storage_account_name = "hyyercodesa"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

resource "azapi_resource" "virtualNetwork_this" {}
