terraform {
  source = "../../../../templates"
}

#include "root" {
#  path = find_in_parent_folders()
#}

include "backend" {
  path = find_in_parent_folders("backend.hcl")
}

locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

generate "tfvars" {
  path              = "terragrunt.auto.tfvars"
  if_exists         = "overwrite"
  disable_signature = true
  contents          = <<-EOF
    azure_region = "${local.region_vars.locals.azure_region}"
  EOF
}