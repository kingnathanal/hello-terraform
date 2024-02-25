locals {
  tfc_hostname     = "app.terraform.io" # For TFE, substitute the custom hostname for your TFE host
  tfc_organization = "hyyercode"
  workspace        = replace(path_relative_to_include(), "/", "-")
}

generate "remote_state" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
      backend "remote" {
        hostname = "${local.tfc_hostname}"
        organization = "${local.tfc_organization}"
        workspaces {
          name = "${local.workspace}"
        }
      }
    }
EOF
}


