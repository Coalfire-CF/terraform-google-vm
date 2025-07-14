resource "google_os_config_patch_deployment" "os_patch" {
  project             = var.project_id
  patch_deployment_id = var.patch_deployment_id
  
  instance_filter {
    group_labels {
      labels = {
        osfamily = var.os_family
      }
    }
    zones = var.zones
  }
  
  patch_config {
    mig_instances_allowed = var.mig_instances_allowed
    reboot_config        = var.reboot_config
    
    # Windows-specific configuration
    dynamic "windows_update" {
      for_each = var.os_family == "windows2022" || var.os_family == "windows" ? [1] : []
      content {
        # Only one of these can be specified at a time
        classifications   = var.windows_update_mode == "classifications" ? var.windows_classifications : null
        excludes         = var.windows_update_mode == "excludes" ? var.windows_excludes : null
        exclusive_patches = var.windows_update_mode == "exclusive_patches" ? var.windows_exclusive_patches : null
      }
    }
    
    # RHEL/CentOS YUM configuration
    dynamic "yum" {
      for_each = var.os_family == "rhel8" || var.os_family == "rhel9" || var.os_family == "rhel" || var.os_family == "centos" ? [1] : []
      content {
        security = var.yum_security
        minimal  = var.yum_minimal
        excludes = var.yum_excludes
      }
    }
    
    # Ubuntu/Debian APT configuration
    dynamic "apt" {
      for_each = var.os_family == "ubuntu2204" || var.os_family == "ubuntu" || var.os_family == "debian" ? [1] : []
      content {
        type     = var.apt_type
        excludes = var.apt_excludes
        exclusive_packages = var.apt_exclusive_packages
      }
    }
    
    # Zypper configuration for SUSE
    dynamic "zypper" {
      for_each = var.os_family == "suse" ? [1] : []
      content {
        with_optional = var.zypper_with_optional
        with_update   = var.zypper_with_update
        categories    = var.zypper_categories
        severities    = var.zypper_severities
        excludes      = var.zypper_excludes
      }
    }
    
    # Pre-patch step (optional)
    dynamic "pre_step" {
      for_each = var.pre_step_enabled ? [1] : []
      content {
        linux_exec_step_config {
          local_path       = var.pre_step_script_path
          allowed_success_codes = var.pre_step_success_codes
          interpreter      = var.pre_step_interpreter
        }
      }
    }
    
    # Post-patch step (optional)
    dynamic "post_step" {
      for_each = var.post_step_enabled ? [1] : []
      content {
        linux_exec_step_config {
          local_path       = var.post_step_script_path
          allowed_success_codes = var.post_step_success_codes
          interpreter      = var.post_step_interpreter
        }
      }
    }
  }
  
  recurring_schedule {
    time_zone {
      id = var.time_zone
    }
    time_of_day {
      hours   = var.hours
      minutes = var.minutes
      seconds = var.seconds
      nanos   = var.nanos
    }
    
    # Weekly schedule
    dynamic "weekly" {
      for_each = var.schedule_type == "weekly" ? [1] : []
      content {
        day_of_week = var.day_of_week
      }
    }
    
    # Monthly schedule
    dynamic "monthly" {
      for_each = var.schedule_type == "monthly" ? [1] : []
      content {
        week_day_of_month {
          week_ordinal = var.week_ordinal
          day_of_week  = var.day_of_week
        }
      }
    }
  }
  
  rollout {
    mode = var.mode
    disruption_budget {
      percentage = var.percentage
    }
  }
  
  lifecycle {
    ignore_changes = [recurring_schedule]
  }
}
