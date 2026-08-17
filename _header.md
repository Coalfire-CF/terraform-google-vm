![Coalfire](coalfire_logo.png)

# Google Cloud VM Terraform Module

## Description

This Google Cloud Virtual Machine module allows you to easily configure and deploy any needed instances. This module will create the virtual machine as well as setup a snapshot schedule. Coalfire has tested this module with Terraform version 1.5.0 and the Hashicorp Google provider versions 4.70 - 5.0.

FedRAMP Compliance: High

### Usage

```hcl
data "google_compute_image" "rhel_9" {
  project = "rhel-cloud"
  filter  = "name=rhel-9-v20231010"
}

module "linux_bastion" {
  source = "github.com/Coalfire-CF/terraform-google-vm"

  project_id = data.terraform_remote_state.bootstrap.outputs.management_project_id

  name        = "linbastion"

  machine_type = "e2-standard-2"

  source_image        = data.google_compute_image.rhel_9.self_link
  disk_size_gb        = 50
  disk_encryption_key = data.terraform_remote_state.bootstrap.outputs.gce_kms_key_id

  zones      = [data.google_compute_zones.available.names[0]]
  subnetwork = data.terraform_remote_state.networking.outputs.subnets_private["dmz"]

  access_config = [{
  }]

  labels = {
    osfamily   = "rhel9",
    ostype     = "linux",
    app        = "management",
    patchgroup = "1"
  }

  service_account = {
    email  = module.bastion-svc-acct.email
    scopes = ["cloud-platform"]
  }

  startup_scripts = [
    {
      path = "${path.module}/path/to/script.sh"
    }
  ]

  tags = ["ext-ssh"]
}
```

