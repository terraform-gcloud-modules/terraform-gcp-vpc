provider "google" {
  project     = var.gcp_project_id
  region      = var.gcp_region
  zone        = var.gcp_zone
}

#-------------------------------------------------------------------------------
# Module "vpc" Configuration
#-------------------------------------------------------------------------------

locals {
  name        = "vpc"
  environment = "dev"
  label_order = ["environment", "name"]
}

module "vpc" {
  source = "../.."

  # Module control
  module_enabled                    = true
  google_compute_network_enabled    = true
  enable_private_ip_alloc           = true
  enable_service_networking         = true

  # General settings
  name        = local.name
  description = "VPC network for dev and testing workloads"
  project_id  = "project-id"
  environment = local.environment
  label_order = local.label_order

  # Network configuration
  auto_create_subnetworks         = false
  routing_mode                    = "GLOBAL"
  mtu                             = 1460
  delete_default_routes_on_create = false
  enable_ula_internal_ipv6        = false
  internal_ipv6_range             = null

  # Shared VPC
  google_compute_shared_vpc_host_enabled = false
  host_project_id   = null
  service_project_id = null

  # Private IP allocation
  private_ip_alloc_name = ["private-ip-range1"]
  prefix_length         = [24]

}