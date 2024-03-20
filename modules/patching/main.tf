resource "google_os_config_patch_deployment" "yum_patch" {
  project = var.project_id
  patch_deployment_id = var.patch_deployment_id
  instance_filter {
    group_labels {
      labels = {
        osfamily = var.os_family,
      }
    }
    zones = var.zones
  }

  patch_config {
    mig_instances_allowed = var.mig_instances_allowed
    reboot_config = var.reboot_config

    yum {
      security = var.security
      minimal = var.minimal
      excludes = var.excludes
    }

    # post_step {
    #   linux_exec_step_config {
    #     gcs_object {
    #       bucket = "my-patch-scripts"
    #       generation_number = "1523477886880" 
    #       object = "linux/post_patch_script"
    #     }
    #   }
    # }
  }

  recurring_schedule {
    time_zone {
      id = var.time_zone
    }

    time_of_day {
      hours = var.hours
      minutes = var.minutes
      seconds = var.seconds
      nanos = var.nanos
    }

    weekly {
      day_of_week = var.day_of_week
    }
  }

  rollout {
    mode = var.mode
    disruption_budget {
      percentage = var.percentage
    }
  }

}