
#-------------------------------------------------------------------------------
# Module "labels" Configuration #
#-------------------------------------------------------------------------------

module "labels" {
  source = "git::https://github.com/terraform-gcloud-modules/terraform-gcp-labels.git?ref=master"

  name        = var.name
  environment = var.environment
  label_order = var.label_order
}

#------------------------------------------------------------------------------------------
# Google_Compute_Network_(VPC)_Configuration #
#-------------------------------------------------------------------------------------------

resource "google_compute_network" "vpc" {
  count = var.google_compute_network_enabled && var.module_enabled ? 1 : 0

  name        = module.labels.id
  description = var.description
  project     = var.project_id

  auto_create_subnetworks         = var.auto_create_subnetworks
  routing_mode                    = var.routing_mode
  mtu                             = var.mtu
  delete_default_routes_on_create = var.delete_default_routes_on_create
  enable_ula_internal_ipv6        = var.enable_ula_internal_ipv6
  internal_ipv6_range             = var.internal_ipv6_range

  depends_on = [var.module_depends_on]

}

#-------------------------------------------------------------------------------
# shared_vpc_Configuration  #
#-------------------------------------------------------------------------------

resource "google_compute_shared_vpc_host_project" "host" {
  count   = var.google_compute_shared_vpc_host_enabled && var.module_enabled ? 1 : 0
  project = var.host_project_id
}

resource "google_compute_shared_vpc_service_project" "service1" {
  count           = var.google_compute_shared_vpc_host_enabled && var.module_enabled ? 1 : 0
  host_project    = google_compute_shared_vpc_host_project.host[count.index].project
  service_project = var.service_project_id
}

#-------------------------------------------------------------------------------
# Private_IP_Configuration  #
#-------------------------------------------------------------------------------

resource "google_compute_global_address" "private_ip_alloc" {
  count         = var.enable_private_ip_alloc ? length(var.private_ip_alloc_name) : 0
  name          = var.private_ip_alloc_name[count.index]
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = var.prefix_length[count.index]
  network       = google_compute_network.vpc[0].self_link
}

#-------------------------------------------------------------------------------
# Private_connection_service_Configuration  #
#-------------------------------------------------------------------------------

resource "google_service_networking_connection" "default" {
  count                   = var.enable_service_networking ? 1 : 0
  network                 = google_compute_network.vpc[0].self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = var.enable_service_networking ? [google_compute_global_address.private_ip_alloc[0].name] : []
}

#-------------------------------------------------------------------------------
# Static Route Configuration
#-------------------------------------------------------------------------------

resource "google_compute_route" "static_route" {
  count = var.enable_static_route && var.module_enabled && var.google_compute_network_enabled ? 1 : 0

  name        = var.route_name
  description = var.route_description

  network    = google_compute_network.vpc[0].name
  dest_range = var.route_dest_range
  priority   = var.route_priority

  next_hop_gateway = var.next_hop_gateway

  tags = var.route_tags
}

#-------------------------------------------------------------------------------
# Cloud NAT Configuration
#-------------------------------------------------------------------------------

resource "google_compute_router" "nat_router" {
  count   = var.enable_nat && var.module_enabled && var.google_compute_network_enabled ? 1 : 0
  name    = "${module.labels.id}-nat-router"
  network = google_compute_network.vpc[0].self_link
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  count  = var.enable_nat && var.module_enabled && var.google_compute_network_enabled ? 1 : 0
  name   = "${module.labels.id}-nat"
  router = google_compute_router.nat_router[0].name
  region = var.region

  nat_ip_allocate_option             = var.nat_ip_allocate_option             # "AUTO_ONLY" or "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat # "ALL_SUBNETWORKS_ALL_IP_RANGES" or list of subnetworks

  min_ports_per_vm = var.min_ports_per_vm

  auto_network_tier = var.nat_network_tier

  log_config {
    enable = var.nat_log_enable
    filter = var.nat_log_filter # "ALL", "ERRORS_ONLY", "TRANSLATIONS_ONLY"
  }
}