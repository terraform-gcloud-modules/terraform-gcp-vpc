provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}

#-------------------------------------------------------------------------------
# Module "vpc" Configuration
#-------------------------------------------------------------------------------

locals {
  name        = "vpc"
  environment = "dev"
  label_order = ["environment", "name"]
  project_id  = "project-id"
}

module "vpc" {
  source = "../.."

  # Module control
  module_enabled                 = true
  google_compute_network_enabled = true
  enable_service_networking      = false

  # General settings
  name        = local.name
  description = "VPC network for dev and testing workloads"
  project_id  = local.project_id
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
  host_project_id                        = null
  service_project_id                     = null

  # Private IP allocation
  enable_private_ip_alloc = false
  private_ip_alloc_name   = ["private-ip-range1"]
  prefix_length           = [24]

  enable_static_route = false
  route_name          = "dev-default-internet"
  route_dest_range    = "0.0.0.0/0"
  route_priority      = 1000
  route_tags          = []

  # Enable NAT
  enable_nat                         = true
  region                             = "us-central1"
  nat_ip_allocate_option             = "AUTO_ONLY" # or "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  min_ports_per_vm                   = 64
  nat_log_enable                     = true
  nat_log_filter                     = "ALL"
  nat_network_tier                   = "STANDARD"

}