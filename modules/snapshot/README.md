# Google Cloud VM Snapshot

## Description

This module is used to create a resource policy for scheduling persistent disk snapshots.

## Usage

The below example creates a daily snapshot schedule with a default max retention time of 14 days.

```hcl
module "snapshot_schedule" {
  source = "github.com/Coalfire-CF/terraform-google-vm//modules/snapshot"

  project_id = "your-project-id"
  region     = "your-region"
  name       = "daily-snapshot"
}

module "linux_bastion" {
  ...

  snapshot_schedule = module.snapshot_schedule.self_link
}
```

To assign the snapshot schedule to a VM, use the `self_link` output from this module and pass that into the `snapshot_schedule` variable of the VM module.

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
| [google_compute_resource_policy.policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_resource_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_days_in_cycle"></a> [days\_in\_cycle](#input\_days\_in\_cycle) | Defines a schedule with units measured in days. The value determines how many days pass between the start of each cycle. Days in cycle for snapshot schedule policy must be 1. | `number` | `1` | no |
| <a name="input_guest_flush"></a> [guest\_flush](#input\_guest\_flush) | Whether to perform a 'guest aware' snapshot. | `bool` | `true` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels, provided as a map | `map(string)` | `null` | no |
| <a name="input_max_retention_days"></a> [max\_retention\_days](#input\_max\_retention\_days) | Maximum age of the snapshot that is allowed to be kept. | `number` | `14` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource policy to create. | `string` | n/a | yes |
| <a name="input_on_source_disk_delete"></a> [on\_source\_disk\_delete](#input\_on\_source\_disk\_delete) | Specifies the behavior to apply to scheduled snapshots when the source disk is deleted. | `string` | `"KEEP_AUTO_SNAPSHOTS"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID where the resources will be created. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where resource policy resides. | `string` | n/a | yes |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | Specifies the schedule frequency. | `string` | `"daily"` | no |
| <a name="input_start_time"></a> [start\_time](#input\_start\_time) | This must be in UTC format that resolves to one of 00:00, 04:00, 08:00, 12:00, 16:00, or 20:00. For example, both 13:00-5 and 08:00 are valid. | `string` | `"00:00"` | no |
| <a name="input_storage_locations"></a> [storage\_locations](#input\_storage\_locations) | Cloud Storage bucket location to store the auto snapshot (regional or multi-regional). | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Resource snapshot ID. |
| <a name="output_policy"></a> [policy](#output\_policy) | Resource snapshot policy details. |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | Resource snapshot self-link. |
<!-- END_TF_DOCS -->