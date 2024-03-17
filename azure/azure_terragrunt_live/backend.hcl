locals {
  tfc_hostname     = "app.terraform.io" # For TFE, substitute the custom hostname for your TFE host
  tfc_organization = "hyyercode"
  workspace        = replace(path_relative_to_include(), "/", "-")
}

generate "remote_state" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    cloud {
      organization = "hyyercode"

      workspaces {
        name = "hello-terraform-api"
      }
    }
EOF
}


