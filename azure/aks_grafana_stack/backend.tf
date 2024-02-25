terraform {
  backend "azurerm" {
    resource_group_name  = "hyyercode-rg"
    storage_account_name = "hyyercodesa"
    container_name       = "tfstate"
    key                  = "aks_grafana_stack/terraform.tfstate"
  }
}