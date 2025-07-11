variable "project_id" {
  type        = string
  description = "The project ID where the resources will be created."
}

variable "patch_deployment_id" {
  type = string
  description = "A name for the patch deployment in the project."
}

variable "os_family" {
  description = "Operating system family (windows, rhel, centos, ubuntu, debian, suse)"
  type        = string
  validation {
    condition = contains(["windows", "windows2022", "rhel", "rhel8", "rhel9", "centos", "ubuntu", "debian", "suse"], var.os_family)
    error_message = "OS family must be one of: windows, windows2022, rhel, rhel8, rhel9, centos, ubuntu, debian, suse."
  }
}

variable "zones" {
  description = "List of zones to target"
  type        = list(string)
  default     = []
}

variable "mig_instances_allowed" {
  description = "Allow patching of MIG instances"
  type        = bool
  default     = true
}

variable "reboot_config" {
  description = "Reboot configuration (DEFAULT, ALWAYS, NEVER)"
  type        = string
  default     = "DEFAULT"
}

# Windows-specific variables
variable "windows_classifications" {
  description = "Windows update classifications"
  type        = list(string)
  default     = ["CRITICAL", "SECURITY", "UPDATES"]
}

variable "windows_excludes" {
  description = "Windows updates to exclude"
  type        = list(string)
  default     = []
}

variable "windows_exclusive_patches" {
  description = "Exclusive Windows patches to install"
  type        = list(string)
  default     = []
}

# YUM-specific variables (RHEL/CentOS)
variable "yum_security" {
  description = "Install security updates only"
  type        = bool
  default     = true
}

variable "yum_minimal" {
  description = "Install minimal updates"
  type        = bool
  default     = false
}

variable "yum_excludes" {
  description = "YUM packages to exclude"
  type        = list(string)
  default     = []
}

# APT-specific variables (Ubuntu/Debian)
variable "apt_type" {
  description = "APT update type (DIST, UPGRADE)"
  type        = string
  default     = "UPGRADE"
}

variable "apt_excludes" {
  description = "APT packages to exclude"
  type        = list(string)
  default     = []
}

variable "apt_exclusive_packages" {
  description = "Exclusive APT packages to install"
  type        = list(string)
  default     = []
}

# Zypper-specific variables (SUSE)
variable "zypper_with_optional" {
  description = "Install optional patches"
  type        = bool
  default     = false
}

variable "zypper_with_update" {
  description = "Install recommended patches"
  type        = bool
  default     = true
}

variable "zypper_categories" {
  description = "Zypper patch categories"
  type        = list(string)
  default     = []
}

variable "zypper_severities" {
  description = "Zypper patch severities"
  type        = list(string)
  default     = []
}

variable "zypper_excludes" {
  description = "Zypper packages to exclude"
  type        = list(string)
  default     = []
}

# Pre/Post step variables
variable "pre_step_enabled" {
  description = "Enable pre-patch step"
  type        = bool
  default     = false
}

variable "pre_step_script_path" {
  description = "Path to pre-patch script"
  type        = string
  default     = ""
}

variable "pre_step_success_codes" {
  description = "Allowed success codes for pre-patch step"
  type        = list(number)
  default     = [0]
}

variable "pre_step_interpreter" {
  description = "Interpreter for pre-patch step"
  type        = string
  default     = "SHELL"
}

variable "post_step_enabled" {
  description = "Enable post-patch step"
  type        = bool
  default     = false
}

variable "post_step_script_path" {
  description = "Path to post-patch script"
  type        = string
  default     = ""
}

variable "post_step_success_codes" {
  description = "Allowed success codes for post-patch step"
  type        = list(number)
  default     = [0]
}

variable "post_step_interpreter" {
  description = "Interpreter for post-patch step"
  type        = string
  default     = "SHELL"
}

# Scheduling variables
variable "schedule_type" {
  description = "Schedule type (weekly, monthly)"
  type        = string
  default     = "weekly"
}

variable "time_zone" {
  description = "Time zone ID"
  type        = string
  default     = "UTC"
}

variable "hours" {
  description = "Hour of the day (0-23)"
  type        = number
  default     = 2
}

variable "minutes" {
  description = "Minute of the hour (0-59)"
  type        = number
  default     = 0
}

variable "seconds" {
  description = "Second of the minute (0-59)"
  type        = number
  default     = 0
}

variable "nanos" {
  description = "Nanoseconds"
  type        = number
  default     = 0
}

variable "day_of_week" {
  description = "Day of the week (MONDAY, TUESDAY, etc.)"
  type        = string
  default     = "SUNDAY"
}

variable "week_ordinal" {
  description = "Week ordinal for monthly schedule (1-5, -1 for last week)"
  type        = number
  default     = 1
}

# Rollout variables
variable "mode" {
  description = "Rollout mode (ZONE_BY_ZONE, CONCURRENT_ZONES)"
  type        = string
  default     = "ZONE_BY_ZONE"
}

variable "percentage" {
  description = "Percentage of instances to patch concurrently"
  type        = number
  default     = 100
}