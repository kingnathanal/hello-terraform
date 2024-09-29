variable "secondary_subscription_id" {
  description = "The subscription id for the second provider"
  type        = string
}

data "azurerm_storage_account" "prime" {
  name                = "hyyercodesa"
  resource_group_name = "hyyercode-rg"
}

provider "azurerm" {
  features {}
  alias           = "second"
  subscription_id = var.secondary_subscription_id
}

data "azurerm_storage_account" "secondary" {
  name                = "hyyercodestsecondary"
  resource_group_name = "hyyercode-rg"
  provider            = azurerm.second
}

output "primary_st_id" {
  value = data.azurerm_storage_account.prime.id
}

output "secondary_st_id" {
  value = data.azurerm_storage_account.secondary.id
}