variable "project_id" {
  type        = string
  description = "The project ID where the resources will be created."
}

variable "region" {
  type        = string
  description = "Region where resource policy resides."
}

variable "name" {
  type        = string
  description = "Name of the resource policy to create."
}

# Retention Policy

variable "max_retention_days" {
  type        = number
  description = "Maximum age of the snapshot that is allowed to be kept."
  default     = 14
}

variable "on_source_disk_delete" {
  type        = string
  description = "Specifies the behavior to apply to scheduled snapshots when the source disk is deleted."
  default     = "KEEP_AUTO_SNAPSHOTS"
}

# Schedule

variable "schedule" {
  type        = string
  description = "Specifies the schedule frequency."
  default     = "daily"
}

variable "days_in_cycle" {
  type        = number
  description = "Defines a schedule with units measured in days. The value determines how many days pass between the start of each cycle. Days in cycle for snapshot schedule policy must be 1."
  default     = 1
}

variable "start_time" {
  type        = string
  description = "This must be in UTC format that resolves to one of 00:00, 04:00, 08:00, 12:00, 16:00, or 20:00. For example, both 13:00-5 and 08:00 are valid."
  default     = "00:00"
}

# Snapthot Properties

variable "labels" {
  type        = map(string)
  description = "Labels, provided as a map"
  default     = null
}

variable "storage_locations" {
  type        = list(string)
  description = "Cloud Storage bucket location to store the auto snapshot (regional or multi-regional)."
  default     = null
}

variable "guest_flush" {
  type        = bool
  description = "Whether to perform a 'guest aware' snapshot."
  default     = true
}
