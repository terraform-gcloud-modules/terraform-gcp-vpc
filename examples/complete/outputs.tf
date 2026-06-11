#-------------------------------------------------------------------------------
# Output VPC
#-------------------------------------------------------------------------------

output "vpc_id" {
  description = "The ID of the VPC network."
  value       = module.vpc.vpc_id
}

output "vpc_name" {
  description = "The name of the VPC network. Pass to subnet and firewall modules."
  value       = module.vpc.vpc_name
}

output "vpc_self_link" {
  description = "The self_link of the VPC. Pass to subnet and firewall modules."
  value       = module.vpc.vpc_self_link
}

output "vpc_gateway_ipv4" {
  description = "The default IPv4 gateway of the VPC."
  value       = module.vpc.vpc_gateway_ipv4
}

output "nat_router_name" {
  description = "Name of the Cloud Router."
  value       = module.vpc.nat_router_name
}

output "nat_router_self_link" {
  description = "Self link of the Cloud Router."
  value       = module.vpc.nat_router_self_link
}

output "nat_name" {
  description = "Name of the Cloud NAT gateway."
  value       = module.vpc.nat_name
}

output "private_ip_alloc_names" {
  description = "Names of the reserved private IP ranges (for Cloud SQL peering)."
  value       = module.vpc.private_ip_alloc_names
}

output "private_ip_alloc_addresses" {
  description = "Reserved private IP addresses allocated for managed services peering."
  value       = module.vpc.private_ip_alloc_addresses
}

output "service_networking_connection_id" {
  description = "The private services connection ID."
  value       = module.vpc.service_networking_connection_id
}

output "static_route_names" {
  description = "Names of static routes created."
  value       = module.vpc.static_route_names
}

output "labels_id" {
  description = "The generated label ID (base name for all resources)."
  value       = module.vpc.labels_id
}
