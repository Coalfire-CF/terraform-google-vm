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

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_disk_resource_policy_attachment.policy_attachment](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_disk_resource_policy_attachment) | resource |
| [google_compute_instance.compute_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_kms_crypto_key_iam_member.crypto_key_encrypter](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_config"></a> [access\_config](#input\_access\_config) | Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet. | <pre>list(object({<br/>    nat_ip       = optional(any, null)<br/>    network_tier = optional(string, "PREMIUM")<br/>  }))</pre> | `[]` | no |
| <a name="input_additional_networks"></a> [additional\_networks](#input\_additional\_networks) | Additional network interface details for GCE, if any. | <pre>list(object({<br/>    network            = optional(string, null)<br/>    subnetwork         = optional(string, null)<br/>    subnetwork_project = optional(string, null)<br/>    network_ip         = optional(any, null)<br/>    access_config = optional(list(object({<br/>      nat_ip       = string<br/>      network_tier = string<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_auto_delete"></a> [auto\_delete](#input\_auto\_delete) | Whether or not the boot disk should be auto-deleted | `bool` | `true` | no |
| <a name="input_can_ip_forward"></a> [can\_ip\_forward](#input\_can\_ip\_forward) | Enable IP forwarding, for NAT instances for example | `bool` | `false` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Enable deletion protection on this instance. Note: you must disable deletion protection before removing the resource, or the instance cannot be deleted and the Terraform run will not complete successfully. | `bool` | `false` | no |
| <a name="input_disk_encryption_key"></a> [disk\_encryption\_key](#input\_disk\_encryption\_key) | The self\_link of the encryption key that is stored in Google Cloud KMS to encrypt this disk. | `string` | n/a | yes |
| <a name="input_disk_labels"></a> [disk\_labels](#input\_disk\_labels) | Labels to be assigned to boot disk, provided as a map | `map(string)` | `{}` | no |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | Boot disk size in GB | `number` | `100` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | Boot disk type, can be either pd-ssd, local-ssd, or pd-standard | `string` | `"pd-ssd"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name of instances, prefixed by '.' | `string` | `""` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels, provided as a map | `map(string)` | `{}` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | Machine type to create, e.g. n1-standard-1 | `string` | `"n1-standard-1"` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | Metadata, provided as a map | `map(string)` | `{}` | no |
| <a name="input_min_cpu_platform"></a> [min\_cpu\_platform](#input\_min\_cpu\_platform) | Specifies a minimum CPU platform. Applicable values are the friendly names of CPU platforms, such as Intel Haswell or Intel Skylake. See the complete list: https://cloud.google.com/compute/docs/instances/specify-min-cpu-platform | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of instances | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | The name or self\_link of the network to attach this interface to. Use network attribute for Legacy or Auto subnetted networks and subnetwork for custom subnetted networks. | `string` | `""` | no |
| <a name="input_network_ip"></a> [network\_ip](#input\_network\_ip) | Private IP address to assign to the instance if desired. | `any` | `""` | no |
| <a name="input_num_instances"></a> [num\_instances](#input\_num\_instances) | Number of instances to create. | `number` | `1` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | `null` | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account. | <pre>object({<br/>    email  = string<br/>    scopes = optional(set(string), ["cloud-platform"])<br/>  })</pre> | n/a | yes |
| <a name="input_snapshot_schedule"></a> [snapshot\_schedule](#input\_snapshot\_schedule) | Name of snapshot schedule | `string` | `null` | no |
| <a name="input_source_image"></a> [source\_image](#input\_source\_image) | Source disk image. If neither source\_image nor source\_image\_family is specified, defaults to the latest public CentOS image. | `string` | `""` | no |
| <a name="input_startup_scripts"></a> [startup\_scripts](#input\_startup\_scripts) | User startup scripts to run when instances spin up | <pre>list(object({<br/>    path = string,<br/>    vars = optional(map(string), {})<br/>  }))</pre> | `null` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | The name of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided. | `string` | `""` | no |
| <a name="input_subnetwork_project"></a> [subnetwork\_project](#input\_subnetwork\_project) | The ID of the project in which the subnetwork belongs. If it is not provided, the provider project is used. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Network tags, provided as a list | `list(string)` | `[]` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Zones where the instances should be created. If not specified, instances will be spread across available zones in the region. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of instance. |
| <a name="output_image"></a> [image](#output\_image) | Self-link of the image. |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | Server-assigned unique identifier of this instance. |
| <a name="output_instances_details"></a> [instances\_details](#output\_instances\_details) | List of all details for compute instances |
| <a name="output_labels"></a> [labels](#output\_labels) | Labels that will be associated with the instance. |
| <a name="output_name"></a> [name](#output\_name) | Name of instance. |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | Private IP address assigned to the instance. |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Public IP address assigned to the instance. |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | Self-link of the instance. |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | Service account attached to the instance. |
| <a name="output_status"></a> [status](#output\_status) | Current status of the instance. |
| <a name="output_tags"></a> [tags](#output\_tags) | Tags that will be associated with the instance. |
| <a name="output_zone"></a> [zone](#output\_zone) | Zone that the instance is located in. |
<!-- END_TF_DOCS -->