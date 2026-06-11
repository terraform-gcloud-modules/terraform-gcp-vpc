#-------------------------------------------------------------------------------
# Module "labels" Configuration #
#-------------------------------------------------------------------------------

module "labels" {
  source = "git::https://github.com/terraform-gcloud-modules/terraform-gcp-labels.git?ref=v0.0.1"

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
  count = (
    var.google_compute_shared_vpc_host_enabled &&
    var.module_enabled &&
    var.host_project_id != ""
  ) ? 1 : 0
  project = var.host_project_id
}

resource "google_compute_shared_vpc_service_project" "service1" {
  count = (
    var.google_compute_shared_vpc_host_enabled &&
    var.module_enabled &&
    var.host_project_id != "" &&
    var.service_project_id != ""
  ) ? 1 : 0

  host_project    = google_compute_shared_vpc_host_project.host[0].project
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
  project       = var.project_id
}

#-------------------------------------------------------------------------------
# Private_connection_service_Configuration  #
#-------------------------------------------------------------------------------

resource "google_service_networking_connection" "default" {
  count                   = var.enable_service_networking ? 1 : 0
  network                 = google_compute_network.vpc[0].self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc[0].name]
  depends_on              = [google_compute_global_address.private_ip_alloc]
}

#-------------------------------------------------------------------------------
# Static Route Configuration
#-------------------------------------------------------------------------------

resource "google_compute_route" "static_route" {
  count = var.enable_static_route && var.module_enabled && var.google_compute_network_enabled ? length(var.static_routes) : 0

  name        = var.static_routes[count.index].name
  description = lookup(var.static_routes[count.index], "description", null)
  network     = google_compute_network.vpc[0].name
  project     = var.project_id
  dest_range  = var.static_routes[count.index].dest_range
  priority    = lookup(var.static_routes[count.index], "priority", 1000)
  tags        = lookup(var.static_routes[count.index], "tags", [])

  # Only one next_hop_* should be set at a time
  next_hop_gateway    = lookup(var.static_routes[count.index], "next_hop_gateway", null)
  next_hop_ip         = lookup(var.static_routes[count.index], "next_hop_ip", null)
  next_hop_instance   = lookup(var.static_routes[count.index], "next_hop_instance", null)
  next_hop_vpn_tunnel = lookup(var.static_routes[count.index], "next_hop_vpn_tunnel", null)
  next_hop_ilb        = lookup(var.static_routes[count.index], "next_hop_ilb", null)

  depends_on = [google_compute_network.vpc]
}


#-------------------------------------------------------------------------------
# Cloud NAT Configuration
#-------------------------------------------------------------------------------

resource "google_compute_router" "nat_router" {
  count   = var.enable_nat && var.module_enabled && var.google_compute_network_enabled ? 1 : 0
  name    = "${module.labels.id}-nat-router"
  network = google_compute_network.vpc[0].self_link
  region  = var.region
  project = var.project_id
}

resource "google_compute_router_nat" "nat" {
  count   = var.enable_nat && var.module_enabled && var.google_compute_network_enabled ? 1 : 0
  name    = "${module.labels.id}-nat"
  router  = google_compute_router.nat_router[0].name
  region  = var.region
  project = var.project_id


  nat_ip_allocate_option             = var.nat_ip_allocate_option             # "AUTO_ONLY" or "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat # "ALL_SUBNETWORKS_ALL_IP_RANGES" or list of subnetworks

  min_ports_per_vm                    = var.min_ports_per_vm
  max_ports_per_vm                    = var.max_ports_per_vm
  enable_endpoint_independent_mapping = var.enable_endpoint_independent_mapping
  tcp_established_idle_timeout_sec    = var.tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec     = var.tcp_transitory_idle_timeout_sec
  udp_idle_timeout_sec                = var.udp_idle_timeout_sec
  icmp_idle_timeout_sec               = var.icmp_idle_timeout_sec
  auto_network_tier                   = var.nat_network_tier

  # Used when source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  dynamic "subnetwork" {
    for_each = var.source_subnetwork_ip_ranges_to_nat == "LIST_OF_SUBNETWORKS" ? var.nat_subnetworks : []
    content {
      name                    = subnetwork.value.name
      source_ip_ranges_to_nat = subnetwork.value.source_ip_ranges_to_nat
    }
  }

  log_config {
    enable = var.nat_log_enable
    filter = var.nat_log_filter
  }

  depends_on = [google_compute_router.nat_router]
}