variable "project_id" {
  type        = string
  description = "The project ID where the resources will be created."
}

variable "patch_deployment_id" {
  type = string
  description = "A name for the patch deployment in the project."
}

variable "os_family" {
  type = string
  description = "OS family of the VMs deployed for the patch schedule."
}

variable "zones" {
  type = list(string)
  description = "Targets VM instances in ANY of these zones."
}

variable "mig_instances_allowed" {
  type = bool
  description = "Allows the patch job to run on Managed instance groups (MIGs)."
  default = true
}

variable "reboot_config" {
  type = string
  description = "Post-patch reboot settings. Possible values are: DEFAULT, ALWAYS, NEVER."
  default = "DEFAULT"
}

variable "security" {
  type = bool
  description = "Adds the --security flag to yum update. Not supported on all platforms."
  default = true
}

variable "minimal" {
  type = bool
  description = "Will cause patch to run yum update-minimal instead."
  default = true
}

variable "excludes" {
  type = list(string)
  description = "List of packages to exclude from update. These packages will be excluded."
  default = null
}

variable "time_zone" {
  type = string
  description = "Time zone for patch schedule"
  default = "America/New_York"
}

variable "hours" {
  type = number
  description = "Hours of day in 24 hour format. Should be from 0 to 23. An API may choose to allow the value 24:00:00 for scenarios like business closing time."
  default = 5
}

variable "minutes" {
  type = number
  description = "Minutes of hour of day. Must be from 0 to 59."
  default = 0
}

variable "seconds" {
  type = number
  description = "Seconds of minutes of the time. Must normally be from 0 to 59."
  default = 0
}

variable "nanos" {
  type = number
  description = "Fractions of seconds in nanoseconds. Must be from 0 to 999,999,999."
  default = 0
}

variable "day_of_week" {
  type = string
  description = "Day of the week patch schedule will run"
}

variable "mode" {
  type = string
  description = "Mode of the patch rollout. Possible values are: ZONE_BY_ZONE, CONCURRENT_ZONES"
  default = "CONCURRENT_ZONES"
}

variable "percentage" {
  type =  number
  description = "Specifies the relative value defined as a percentage, which will be multiplied by a reference value"
  default = 50
}