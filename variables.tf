#-------------------------------------------------------------------------------------
# Module_labels_variable #
#-------------------------------------------------------------------------------------

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment name"
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. `name`,`application`."
}

variable "project_id" {
  type        = string
  default     = ""
  description = "(Optional) The ID of the project in which the resource belongs. If it is not set, the provider project is used."
}

variable "name" {
  type        = string
  default     = ""
  description = "(Optional) The name of the VPC. The name will be used to prefix all associacted resources also. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression \"[a-z]([-a-z0-9]*[a-z0-9])?\" which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash. Default is \"main\"."

}

#---------------------------------------------------------------------------------------------------
# Google_Compute_Network_(VPC)_variable #
#---------------------------------------------------------------------------------------------------

variable "description" {
  type        = string
  default     = ""
  description = "(Optional) An optional description of the VPC. The resource must be recreated to modify this field.Default is ''."

}

variable "routing_mode" {
  type        = string
  default     = "REGIONAL"
  description = "(Optional) The network-wide routing mode to use. If set to 'REGIONAL', this network's cloud routers will only advertise routes with subnetworks of this network in the same region as the router. If set to 'GLOBAL', this network's cloud routers will advertise routes with all subnetworks of this network, across regions. Possible values are 'REGIONAL' and 'GLOBAL'. Default is 'REGIONAL'."
}

variable "delete_default_routes_on_create" {
  type        = bool
  default     = false
  description = "(Optional) If set to true, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted."

}

variable "auto_create_subnetworks" {
  type        = bool
  default     = false
  description = "(Optional) When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the '10.128.0.0/9' address range. When set to 'false', the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources. Default is 'false'."

}

variable "mtu" {
  type        = string
  default     = 1460
  description = "(Optional) Maximum Transmission Unit in bytes. The minimum value for this field is 1460 and the maximum value is 1500 bytes. Default is '1460'."

}

variable "enable_ula_internal_ipv6" {
  type        = bool
  default     = false
  description = "(Optional) Enable ULA internal ipv6 on this network. Enabling this feature will assign a /48 from google defined ULA prefix fd20::/20."

}

variable "internal_ipv6_range" {
  type        = string
  default     = null
  description = "(Optional) When enabling ula internal ipv6, caller optionally can specify the /48 range they want from the google defined ULA prefix fd20::/20. The input must be a valid /48 ULA IPv6 address and must be within the fd20::/20. Operation will fail if the speficied /48 is already in used by another resource. If the field is not speficied, then a /48 range will be randomly allocated from fd20::/20 and returned via this field."

}

variable "module_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Whether to create resources within the module or not. Default is 'true'."

}

variable "module_depends_on" {
  type        = any
  default     = []
  description = "(Optional) A list of external resources the module depends_on. Default is '[]'."

}

#---------------------------------------------------------------------------------------------------------
# shared_vpc_variable #
#----------------------------------------------------------------------------------------------------------

variable "host_project_id" {
  description = "Google Cloud Project ID"
  type        = string
  default     = ""
}

variable "service_project_id" {
  description = "Project ID of the service project"
  type        = string
  default     = ""
}

variable "google_compute_shared_vpc_host_enabled" {
  type        = bool
  default     = true
  description = "Set to false to disable the creation of Google Compute Engine shared VPC host project."
}

#---------------------------------------------------------------------------------------------------------
# private_IP_&_service_networking_variable #
#----------------------------------------------------------------------------------------------------------

variable "enable_private_ip_alloc" {
  type        = bool
  default     = true
  description = "Enable allocation of a private IP address range for VPC peering."
}

variable "private_ip_alloc_name" {
  description = "List of names for the private IP allocations"
  type        = list(string)
}

variable "prefix_length" {
  description = "List of prefix lengths for the private IP allocations"
  type        = list(number)
}
variable "enable_service_networking" {
  description = "Whether to enable service networking"
  type        = bool
  default     = true
}

variable "google_compute_network_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether the Google Compute Engine network should be enabled"
}

variable "enable_static_route" {
  type        = bool
  default     = false
  description = "Enable or disable creation of a static route in the VPC."
}

variable "route_name" {
  type        = string
  description = "Name of the static route to be created."
}

variable "route_description" {
  type        = string
  default     = "Static route"
  description = "Description of the static route."
}

variable "route_dest_range" {
  type        = string
  description = "Destination IPv4 CIDR range for the static route (e.g., 0.0.0.0/0)."
}

variable "route_priority" {
  type        = number
  default     = 1000
  description = "Priority of the route (0–65535). Lower values have higher precedence."
}

variable "next_hop_gateway" {
  type        = string
  default     = "default-internet-gateway"
  description = "Next hop gateway for the route. Use 'default-internet-gateway' for internet access."
}

variable "route_tags" {
  type        = list(string)
  default     = []
  description = "List of instance network tags to which this route will apply. Leave empty to apply to all instances."
}

variable "enable_nat" {
  type        = bool
  default     = false
  description = "Enable or disable Cloud NAT for the VPC. Set to true to create NAT resources."
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "The region in which the Cloud NAT and Cloud Router will be deployed."
}

variable "nat_ip_allocate_option" {
  type        = string
  default     = "AUTO_ONLY"
  description = "Specifies how NAT IPs are allocated. Options: 'AUTO_ONLY' for automatic IP allocation, 'MANUAL_ONLY' for manually specified IPs."
}

variable "source_subnetwork_ip_ranges_to_nat" {
  type        = string
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  description = "Determines which IP ranges in the subnetworks should use NAT. Options include 'ALL_SUBNETWORKS_ALL_IP_RANGES' or a list of specific subnetwork IP ranges."
}

variable "min_ports_per_vm" {
  type        = number
  default     = 64
  description = "Minimum number of NAT ports allocated per VM. This defines how many simultaneous outbound connections a VM can make through NAT."
}

variable "nat_log_enable" {
  type        = bool
  default     = false
  description = "Enable or disable logging for Cloud NAT. Set to true to log NAT activity."
}

variable "nat_log_filter" {
  type        = string
  default     = "ALL"
  description = "Filter for NAT logs. Options: 'ALL', 'ERRORS_ONLY', 'TRANSLATIONS_ONLY'."
}

variable "nat_network_tier" {
  type        = string
  default     = "PREMIUM"
  description = "Network Service Tier for Cloud NAT. Options: PREMIUM or STANDARD."
}