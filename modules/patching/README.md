# Google Cloud VM OS Patching

## Description

This module is used to create a OS Patching Schedule for VMs based on a label for yum specific OS updates.

## Usage

The below example creates a OS Patching Schedule targeting RHEL8 VMs.

```hcl
module "rhel8_os_patching" {
  source = "github.com/Coalfire-CF/terraform-google-vm//modules/patching"
  project_id = "your-project-id"

  patch_deployment_id = "rhel8-patching-schedule"
  os_family = "rhel8"
  zones = ["us-central1-a", "us-central1-b", "us-central1-c"]
  day_of_week = "WEDNESDAY"

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
| [google_os_config_patch_deployment.yum_patch](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/os_config_patch_deployment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_day_of_week"></a> [day\_of\_week](#input\_day\_of\_week) | Day of the week patch schedule will run | `string` | n/a | yes |
| <a name="input_excludes"></a> [excludes](#input\_excludes) | List of packages to exclude from update. These packages will be excluded. | `list(string)` | `null` | no |
| <a name="input_hours"></a> [hours](#input\_hours) | Hours of day in 24 hour format. Should be from 0 to 23. An API may choose to allow the value 24:00:00 for scenarios like business closing time. | `number` | `5` | no |
| <a name="input_mig_instances_allowed"></a> [mig\_instances\_allowed](#input\_mig\_instances\_allowed) | Allows the patch job to run on Managed instance groups (MIGs). | `bool` | `true` | no |
| <a name="input_minimal"></a> [minimal](#input\_minimal) | Will cause patch to run yum update-minimal instead. | `bool` | `true` | no |
| <a name="input_minutes"></a> [minutes](#input\_minutes) | Minutes of hour of day. Must be from 0 to 59. | `number` | `0` | no |
| <a name="input_mode"></a> [mode](#input\_mode) | Mode of the patch rollout. Possible values are: ZONE\_BY\_ZONE, CONCURRENT\_ZONES | `string` | `"CONCURRENT_ZONES"` | no |
| <a name="input_nanos"></a> [nanos](#input\_nanos) | Fractions of seconds in nanoseconds. Must be from 0 to 999,999,999. | `number` | `0` | no |
| <a name="input_os_family"></a> [os\_family](#input\_os\_family) | OS family of the VMs deployed for the patch schedule. | `string` | n/a | yes |
| <a name="input_patch_deployment_id"></a> [patch\_deployment\_id](#input\_patch\_deployment\_id) | A name for the patch deployment in the project. | `string` | n/a | yes |
| <a name="input_percentage"></a> [percentage](#input\_percentage) | Specifies the relative value defined as a percentage, which will be multiplied by a reference value | `number` | `50` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID where the resources will be created. | `string` | n/a | yes |
| <a name="input_reboot_config"></a> [reboot\_config](#input\_reboot\_config) | Post-patch reboot settings. Possible values are: DEFAULT, ALWAYS, NEVER. | `string` | `"DEFAULT"` | no |
| <a name="input_seconds"></a> [seconds](#input\_seconds) | Seconds of minutes of the time. Must normally be from 0 to 59. | `number` | `0` | no |
| <a name="input_security"></a> [security](#input\_security) | Adds the --security flag to yum update. Not supported on all platforms. | `bool` | `true` | no |
| <a name="input_time_zone"></a> [time\_zone](#input\_time\_zone) | Time zone for patch schedule | `string` | `"America/New_York"` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Targets VM instances in ANY of these zones. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_os_patching_id"></a> [os\_patching\_id](#output\_os\_patching\_id) | n/a |
| <a name="output_os_patching_name"></a> [os\_patching\_name](#output\_os\_patching\_name) | n/a |
<!-- END_TF_DOCS -->
