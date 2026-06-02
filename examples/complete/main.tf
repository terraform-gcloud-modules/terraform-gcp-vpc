provider "google" {
  project = var.project_id
  region  = var.region
}

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

  #---------------------------------------------------------------------------
  # VPC Network
  #---------------------------------------------------------------------------
  description                     = "Core VPC for ${var.name} (${var.environment})"
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  mtu                             = 1460
  delete_default_routes_on_create = false
  enable_ula_internal_ipv6        = false

  #---------------------------------------------------------------------------
  # Cloud NAT + Cloud Router
  # Subnets will be NATed via their subnet module referencing this VPC.
  #---------------------------------------------------------------------------
  enable_nat                          = true
  region                              = var.region
  nat_ip_allocate_option              = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  min_ports_per_vm                    = 64
  max_ports_per_vm                    = 4096
  enable_endpoint_independent_mapping = false
  nat_network_tier                    = "PREMIUM"
  nat_log_enable                      = true
  nat_log_filter                      = "ERRORS_ONLY"

  #---------------------------------------------------------------------------
  # Private IP Allocation for Cloud SQL 
  #---------------------------------------------------------------------------
  enable_private_ip_alloc = true
  private_ip_alloc_name   = ["${var.name}-${var.environment}-google-managed-range"]
  prefix_length           = [16]

  enable_service_networking = false

  #---------------------------------------------------------------------------
  # Static Routes
  #---------------------------------------------------------------------------
  enable_static_route = true
  static_routes = [
    {
      name             = "${var.name}-${var.environment}-default-internet"
      dest_range       = "0.0.0.0/0"
      description      = "Default route to the public internet"
      priority         = 1000
      next_hop_gateway = "default-internet-gateway"
    }
  ]

  #---------------------------------------------------------------------------
  # Shared VPC 
  # Enable if this project should act as a Shared VPC host.
  #---------------------------------------------------------------------------
  google_compute_shared_vpc_host_enabled = false
  host_project_id                        = ""
  service_project_id                     = ""
}
