locals {
  startup_scripts = var.startup_scripts == null ? null : join("\n", [
    for script in var.startup_scripts : templatefile(
      script.path,
      try(script.vars, {})
    )
  ])
}

/*************************************************
 Snapshot schedule
*************************************************/

resource "google_compute_disk_resource_policy_attachment" "policy_attachment" {
  count   = var.snapshot_schedule != null ? var.num_instances : 0
  project = var.project_id

  name = var.snapshot_schedule
  disk = google_compute_instance.compute_instance[count.index].name
  zone = element(var.zones, count.index)
}

/*************************************************
 Instances
*************************************************/

locals {
  domain_name = ".${var.domain_name}"
}

resource "google_compute_instance" "compute_instance" {
  count   = var.num_instances
  project = var.project_id

  name     = var.num_instances == 1 ? var.name : "${var.name}${count.index + 1}"
  hostname = var.domain_name == "" ? null : var.num_instances == 1 ? "${var.name}${local.domain_name}" : "${var.name}${count.index + 1}${local.domain_name}"

  machine_type     = var.machine_type
  min_cpu_platform = var.min_cpu_platform
  can_ip_forward   = var.can_ip_forward

  boot_disk {
    auto_delete = var.auto_delete
    initialize_params {
      size  = var.disk_size_gb
      type  = var.disk_type
      image = var.source_image
    }
    kms_key_self_link = var.disk_encryption_key
    #checkov:skip=CKV_GCP_39:Shielded VM enablement is unnecessary
  }

  zone = element(var.zones, count.index)

  network_interface {
    network            = var.network
    subnetwork         = var.subnetwork
    subnetwork_project = var.subnetwork_project
    network_ip         = length(var.network_ip) > 0 ? try(var.network_ip[count.index], var.network_ip) : null
    dynamic "access_config" {
      #checkov:skip=CKV_GCP_40:VMs have public IP addresses
      for_each = var.access_config
      content {
        nat_ip       = try(access_config.value.nat_ip[count.index], access_config.value.nat_ip)
        network_tier = access_config.value.network_tier
      }
    }
  }

  dynamic "network_interface" {
    for_each = var.additional_networks
    content {
      network            = network_interface.value.network
      subnetwork         = network_interface.value.subnetwork
      subnetwork_project = network_interface.value.subnetwork_project
      network_ip         = network_interface.value.network_ip
      dynamic "access_config" {
        for_each = network_interface.value.access_config
        content {
          nat_ip       = access_config.value.nat_ip
          network_tier = access_config.value.network_tier
        }
      }
    }
  }

  deletion_protection = var.deletion_protection

  labels = var.labels

  metadata = merge(var.metadata, {
    #checkov:skip=CKV_GCP_32:Project-wide SSH keys are necessary 
    windows-startup-script-ps1 = (var.startup_scripts != null && strcontains(lower(var.source_image), "win") == true) ? local.startup_scripts : null
    startup-script             = (var.startup_scripts != null && strcontains(lower(var.source_image), "win") == false) ? local.startup_scripts : null
  })

  dynamic "service_account" {
    for_each = var.service_account == null ? [] : [var.service_account]
    content {
      email  = lookup(service_account.value, "email", null)
      scopes = lookup(service_account.value, "scopes", null)
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      # do not clear out any windows passwords and ssh keys
      metadata["windows-keys"],
      metadata["ssh-keys"],
      # do not recreate instance when newer image available
      boot_disk.0.initialize_params.0.image,
      # do not touch resource policies
      resource_policies
    ]
  }
}
