terraform {
  cloud {
    organization = "hyyercode"

    workspaces {
      name = "hello-terraform-api"
    }
  }
}

