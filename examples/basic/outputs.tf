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