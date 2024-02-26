resource "google_compute_resource_policy" "policy" {

  name    = var.name
  project = var.project_id
  region  = var.region

  snapshot_schedule_policy {
    retention_policy {
      max_retention_days    = var.max_retention_days
      on_source_disk_delete = var.on_source_disk_delete
    }

    schedule {

      dynamic "daily_schedule" {
        for_each = var.schedule == "daily" ? [1] : []
        content {
          days_in_cycle = var.days_in_cycle
          start_time    = var.start_time
        }
      }

    }

    snapshot_properties {
      labels            = var.labels
      storage_locations = var.storage_locations != null ? var.storage_locations : [var.region]
      guest_flush       = var.guest_flush
    }
  }
}
