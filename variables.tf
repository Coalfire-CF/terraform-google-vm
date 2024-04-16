variable "project_id" {
  type        = string
  description = "The GCP project ID"
  default     = null
}

variable "num_instances" {
  type        = number
  description = "Number of instances to create."
  default     = 1
}

variable "machine_type" {
  type        = string
  description = "Machine type to create, e.g. n1-standard-1"
  default     = "n1-standard-1"
}

variable "min_cpu_platform" {
  type        = string
  description = "Specifies a minimum CPU platform. Applicable values are the friendly names of CPU platforms, such as Intel Haswell or Intel Skylake. See the complete list: https://cloud.google.com/compute/docs/instances/specify-min-cpu-platform"
  default     = null
}

variable "can_ip_forward" {
  type        = bool
  description = "Enable IP forwarding, for NAT instances for example"
  default     = false
}

variable "zones" {
  type        = list(string)
  description = "Zones where the instances should be created. If not specified, instances will be spread across available zones in the region."
  default     = null
}

variable "name" {
  type        = string
  description = "Name of instances"
}

variable "domain_name" {
  type        = string
  description = "Domain name of instances, prefixed by '.'"
  default     = ""
}

variable "deletion_protection" {
  type        = bool
  description = "Enable deletion protection on this instance. Note: you must disable deletion protection before removing the resource, or the instance cannot be deleted and the Terraform run will not complete successfully."
  default     = false
}

variable "tags" {
  type        = list(string)
  description = "Network tags, provided as a list"
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "Labels, provided as a map"
  default     = {}
}

###########################
# Public IP
###########################
variable "access_config" {
  description = "Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet."
  type = list(object({
    nat_ip       = optional(any, null)
    network_tier = optional(string, "PREMIUM")
  }))
  default = []
}

###########
# metadata
###########

variable "metadata" {
  type        = map(string)
  description = "Metadata, provided as a map"
  default     = {}
}

variable "startup_scripts" {
  type = list(object({
    path = string,
    vars = optional(map(string), {})
  }))
  description = "User startup scripts to run when instances spin up"
  default     = null
}

##################
# service_account
##################

variable "service_account" {
  type = object({
    email  = string
    scopes = optional(set(string), ["cloud-platform"])
  })
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account."
}

#######
# disk
#######

variable "source_image" {
  type        = string
  description = "Source disk image. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  default     = ""
}

variable "disk_labels" {
  type        = map(string)
  description = "Labels to be assigned to boot disk, provided as a map"
  default     = {}
}

variable "disk_size_gb" {
  type        = number
  description = "Boot disk size in GB"
  default     = 100
}

variable "disk_type" {
  type        = string
  description = "Boot disk type, can be either pd-ssd, local-ssd, or pd-standard"
  default     = "pd-ssd"
}

variable "disk_encryption_key" {
  type        = string
  description = "The self_link of the encryption key that is stored in Google Cloud KMS to encrypt this disk."
}

variable "snapshot_schedule" {
  type        = string
  description = "Name of snapshot schedule"
  default     = null
}

variable "auto_delete" {
  type        = bool
  description = "Whether or not the boot disk should be auto-deleted"
  default     = true
}

####################
# network_interface
####################

variable "subnetwork" {
  type        = string
  description = "The name of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided."
  default     = ""
}

variable "subnetwork_project" {
  type        = string
  description = "The ID of the project in which the subnetwork belongs. If it is not provided, the provider project is used."
  default     = ""
}

variable "network" {
  type        = string
  description = "The name or self_link of the network to attach this interface to. Use network attribute for Legacy or Auto subnetted networks and subnetwork for custom subnetted networks."
  default     = ""
}

variable "network_ip" {
  type        = any
  description = "Private IP address to assign to the instance if desired."
  default     = ""
}

variable "additional_networks" {
  description = "Additional network interface details for GCE, if any."
  default     = []
  type = list(object({
    network            = optional(string, null)
    subnetwork         = optional(string, null)
    subnetwork_project = optional(string, null)
    network_ip         = optional(any, null)
    access_config = optional(list(object({
      nat_ip       = string
      network_tier = string
    })), [])
  }))
}
