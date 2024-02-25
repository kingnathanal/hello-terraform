terraform {
  cloud {
    organization = "hyyercode"

    workspaces {
      name = "hello-terraform-ws"
    }
  }
/*
  credentials "app.terraform.io" {
    token = "6WW7PYIhzKSYmw.atlasv1.KQZE9UtP5n1khWMULHGPgt8V8uhk2uRLEYdloNDvDpYP4SqZZxI0tkKbHa9BkQPGgP0"
    }
*/
}

