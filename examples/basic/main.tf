# ------------------------------------------------------------------------------
# Provider Configuration
# ------------------------------------------------------------------------------

provider "google" {
  project = var.project_id
  region  = var.region
}

# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------

locals {
  name        = var.name
  environment = var.environment
  label_order = var.label_order
}

module "vpc" {
  source      = "../.."
  name        = local.name
  environment = local.environment
  label_order = local.label_order
  project_id  = var.project_id

  module_enabled                 = true
  google_compute_network_enabled = true

  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}