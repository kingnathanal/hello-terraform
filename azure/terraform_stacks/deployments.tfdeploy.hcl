store "varset" "creds" {
  name       = "Azure Creds"
  category = "terraform"
}

identity_token "azurerm" {
  audience = ["api://AzureADTokenExchange"]
}

locals {
    tf_organization    = "hyyercode"
    tf_project_name    = "Default Project"
}

deployment "development" {
  inputs = {
    identity_token = identity_token.azurerm.jwt

    azure_region = "eastus2"
    subscription_id = "cba339b6-ea03-48de-912f-7213c3f451ae"
    client_id = store.varset.creds.ARM_CLIENT_ID
    tenant_id = store.varset.creds.ARM_TENANT_ID

  }
}

deployment "test" {
  inputs = {
    identity_token = identity_token.azurerm.jwt

    azure_region = "eastus2"
    subscription_id = "ca8d284a-c1ea-493c-873d-ac8b31b6616e"
    client_id = store.varset.creds.ARM_CLIENT_ID
    tenant_id = store.varset.creds.ARM_TENANT_ID
  }
}