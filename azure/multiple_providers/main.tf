

module "hyyercode-st" {
  source                 = "../test_module"
  secondary_subscription_id = var.secondary_subscription_id
  //providers = {
  //  azurerm.second = azurerm.second
  //}
}

variable "secondary_subscription_id" {
  description = "The subscription id for the second provider"
  type        = string
}