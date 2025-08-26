#-------------------------------------------------------------------------------
# Google_Provider_variables #
#-------------------------------------------------------------------------------

variable "gcp_project_id" {
  type        = string
  default     = "project-1"
  description = "Google Cloud project ID"
}

variable "gcp_region" {
  type        = string
  default     = "europe-west3"
  description = "Google Cloud region"
}

variable "gcp_zone" {
  type        = string
  default     = "Europe-west3-c"
  description = "Google Cloud zone"
}