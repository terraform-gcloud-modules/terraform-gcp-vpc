provider "google" {
  project     = var.gcp_project_id
  region      = var.gcp_region
  zone        = var.gcp_zone
}

#-------------------------------------------------------------------------------
# Module "vpc" Configuration
#-------------------------------------------------------------------------------

module "vpc" {
  source = "../.."

  name        = "my-vpc"
  environment = "dev"
  label_order = ["environment", "name"]

  module_enabled                  = true
  project_id                      = "project-1"
  description                     = "Demo VPC"
  auto_create_subnetworks         = false
  routing_mode                    = "GLOBAL"
  mtu                             = 1460
  delete_default_routes_on_create = false
  enable_ula_internal_ipv6        = false
  internal_ipv6_range             = null

  bgp_best_path_selection_mode = "LEGACY"
  bgp_always_compare_med       = false
  bgp_inter_region_cost        = null


  google_compute_shared_vpc_host_enabled = false


  host_project_id    = "my-host-project"
  service_project_id = "my-service-project"

  enable_private_ip_alloc = false
  private_ip_alloc_name   = ["private-ip-range-1"]
  prefix_length           = [16]

  enable_service_networking = false
}