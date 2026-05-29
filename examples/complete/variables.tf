variable "project_id" {
  description = "The GCP project ID where all resources will be created."
  type        = string
  default     = null
}

variable "name" {
  description = "Base name used for all resources (e.g. myapp, platform)."
  type        = string
  default     = "myapp"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "region" {
  description = "GCP region for the Cloud Router and NAT gateway."
  type        = string
  default     = "us-central1"
}

variable "label_order" {
  type        = list(string)
  default     = ["name", "environment"]
  description = "Order of segments in the label ID, e.g. [\"name\", \"environment\"]."
}
