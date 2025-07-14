# Google Cloud VM OS Patching

## Description

This module is used to create a OS Patching Schedule for VMs based on a label for yum specific OS updates.

## Usage

The below example creates a OS Patching Schedule targeting RHEL8 VMs.

```hcl

#Example: Basic RHEL Patch with defaults 
module "rhel8_os_patching" {
  source     = "github.com/Coalfire-CF/terraform-google-vm//modules/patching?ref=vX.X.X"
  project_id = var.project_id

  patch_deployment_id = "rhel8-patching-schedule"
  os_family           = "rhel8"
  zones               = ["us-central1-a", "us-central1-b", "us-central1-c"]
  day_of_week         = "WEDNESDAY"
  yum_security        = true
  yum_minimal         = true
}

# Example: Windows patch deployment with exclusive patches
module "windows_os_patching" {
  source     = "github.com/Coalfire-CF/terraform-google-vm//modules/patching?ref=vX.X.X"
  project_id = var.project_id

  patch_deployment_id     = "windows2022-patching-schedule"
  os_family               = "windows2022"
  zones                   = ["us-central1-a", "us-central1-b", "us-central1-c"]
  
  # Windows-specific settings - using exclusive patches mode
  windows_update_mode       = "exclusive_patches"
  windows_exclusive_patches = ["KB5012345", "KB5067890"]
  
  # Schedule for second Wednesday of each month
  schedule_type = "monthly"
  week_ordinal  = 2
  day_of_week   = "WEDNESDAY"
  hours         = 3
  minutes       = 0
  
  # Rollout settings
  mode       = "ZONE_BY_ZONE"
  percentage = 50
}

# Example 4: Multi-OS deployment using for_each
locals {
  os_configs = {
    windows = {
      os_family               = "windows"
      patch_deployment_id     = "windows-patches"
      windows_update_mode     = "classifications"
      windows_classifications = ["CRITICAL", "SECURITY"]
      schedule_type          = "monthly"
      week_ordinal           = 2
      day_of_week            = "SUNDAY"
      hours                  = 3
    }
    
    rhel = {
      os_family           = "rhel"
      patch_deployment_id = "rhel-patches"
      yum_security       = true
      yum_minimal        = false
      schedule_type      = "weekly"
      day_of_week        = "SATURDAY"
      hours              = 2
    }
    
    ubuntu = {
      os_family           = "ubuntu"
      patch_deployment_id = "ubuntu-patches"
      apt_type           = "UPGRADE"
      schedule_type      = "weekly"
      day_of_week        = "TUESDAY"
      hours              = 1
      reboot_config      = "NEVER"
    }
  }
}

module "multi_os_patches" {
  source = "./modules/os-patch-deployment"
  
  for_each = local.os_configs
  
  project_id          = "my-project"
  patch_deployment_id = each.value.patch_deployment_id
  os_family          = each.value.os_family
  zones              = ["us-central1-a", "us-central1-b"]
  
  # Windows settings
  windows_update_mode     = lookup(each.value, "windows_update_mode", "classifications")
  windows_classifications = lookup(each.value, "windows_classifications", ["CRITICAL", "SECURITY", "UPDATE"])
  windows_excludes       = lookup(each.value, "windows_excludes", [])
  windows_exclusive_patches = lookup(each.value, "windows_exclusive_patches", [])
  
  # RHEL/CentOS settings
  yum_security = lookup(each.value, "yum_security", true)
  yum_minimal  = lookup(each.value, "yum_minimal", false)
  
  # Ubuntu settings
  apt_type = lookup(each.value, "apt_type", "UPGRADE")
  
  # Schedule settings
  schedule_type = each.value.schedule_type
  day_of_week   = each.value.day_of_week
  hours         = each.value.hours
  minutes       = lookup(each.value, "minutes", 0)
  
  # Optional settings
  week_ordinal  = lookup(each.value, "week_ordinal", 1)
  reboot_config = lookup(each.value, "reboot_config", "DEFAULT")
  
  # Rollout settings
  mode       = lookup(each.value, "mode", "ZONE_BY_ZONE")
  percentage = lookup(each.value, "percentage", 100)
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
| [google_os_config_patch_deployment.os_patch](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/os_config_patch_deployment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apt_excludes"></a> [apt\_excludes](#input\_apt\_excludes) | APT packages to exclude | `list(string)` | `[]` | no |
| <a name="input_apt_exclusive_packages"></a> [apt\_exclusive\_packages](#input\_apt\_exclusive\_packages) | Exclusive APT packages to install | `list(string)` | `[]` | no |
| <a name="input_apt_type"></a> [apt\_type](#input\_apt\_type) | APT update type (DIST, UPGRADE) | `string` | `"UPGRADE"` | no |
| <a name="input_day_of_week"></a> [day\_of\_week](#input\_day\_of\_week) | Day of the week (MONDAY, TUESDAY, etc.) | `string` | `"WEDNESDAY"` | no |
| <a name="input_hours"></a> [hours](#input\_hours) | Hour of the day (0-23) | `number` | `2` | no |
| <a name="input_mig_instances_allowed"></a> [mig\_instances\_allowed](#input\_mig\_instances\_allowed) | Allow patching of MIG instances | `bool` | `true` | no |
| <a name="input_minutes"></a> [minutes](#input\_minutes) | Minute of the hour (0-59) | `number` | `0` | no |
| <a name="input_mode"></a> [mode](#input\_mode) | Rollout mode (ZONE\_BY\_ZONE, CONCURRENT\_ZONES) | `string` | `"ZONE_BY_ZONE"` | no |
| <a name="input_nanos"></a> [nanos](#input\_nanos) | Nanoseconds | `number` | `0` | no |
| <a name="input_os_family"></a> [os\_family](#input\_os\_family) | Operating system family (windows, rhel, centos, ubuntu, debian, suse) | `string` | n/a | yes |
| <a name="input_patch_deployment_id"></a> [patch\_deployment\_id](#input\_patch\_deployment\_id) | A name for the patch deployment in the project. | `string` | n/a | yes |
| <a name="input_percentage"></a> [percentage](#input\_percentage) | Percentage of instances to patch concurrently | `number` | `100` | no |
| <a name="input_post_step_enabled"></a> [post\_step\_enabled](#input\_post\_step\_enabled) | Enable post-patch step | `bool` | `false` | no |
| <a name="input_post_step_interpreter"></a> [post\_step\_interpreter](#input\_post\_step\_interpreter) | Interpreter for post-patch step | `string` | `"SHELL"` | no |
| <a name="input_post_step_script_path"></a> [post\_step\_script\_path](#input\_post\_step\_script\_path) | Path to post-patch script | `string` | `""` | no |
| <a name="input_post_step_success_codes"></a> [post\_step\_success\_codes](#input\_post\_step\_success\_codes) | Allowed success codes for post-patch step | `list(number)` | <pre>[<br/>  0<br/>]</pre> | no |
| <a name="input_pre_step_enabled"></a> [pre\_step\_enabled](#input\_pre\_step\_enabled) | Enable pre-patch step | `bool` | `false` | no |
| <a name="input_pre_step_interpreter"></a> [pre\_step\_interpreter](#input\_pre\_step\_interpreter) | Interpreter for pre-patch step | `string` | `"SHELL"` | no |
| <a name="input_pre_step_script_path"></a> [pre\_step\_script\_path](#input\_pre\_step\_script\_path) | Path to pre-patch script | `string` | `""` | no |
| <a name="input_pre_step_success_codes"></a> [pre\_step\_success\_codes](#input\_pre\_step\_success\_codes) | Allowed success codes for pre-patch step | `list(number)` | <pre>[<br/>  0<br/>]</pre> | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID where the resources will be created. | `string` | n/a | yes |
| <a name="input_reboot_config"></a> [reboot\_config](#input\_reboot\_config) | Reboot configuration (DEFAULT, ALWAYS, NEVER) | `string` | `"DEFAULT"` | no |
| <a name="input_schedule_type"></a> [schedule\_type](#input\_schedule\_type) | Schedule type (weekly, monthly) | `string` | `"weekly"` | no |
| <a name="input_seconds"></a> [seconds](#input\_seconds) | Second of the minute (0-59) | `number` | `0` | no |
| <a name="input_time_zone"></a> [time\_zone](#input\_time\_zone) | Time zone ID | `string` | `"UTC"` | no |
| <a name="input_week_ordinal"></a> [week\_ordinal](#input\_week\_ordinal) | Week ordinal for monthly schedule (1-5, -1 for last week) | `number` | `1` | no |
| <a name="input_windows_classifications"></a> [windows\_classifications](#input\_windows\_classifications) | Windows update classifications (only used when windows\_update\_mode = 'classifications') | `list(string)` | <pre>[<br/>  "CRITICAL",<br/>  "SECURITY",<br/>  "UPDATE"<br/>]</pre> | no |
| <a name="input_windows_excludes"></a> [windows\_excludes](#input\_windows\_excludes) | Windows updates to exclude (only used when windows\_update\_mode = 'excludes') | `list(string)` | `[]` | no |
| <a name="input_windows_exclusive_patches"></a> [windows\_exclusive\_patches](#input\_windows\_exclusive\_patches) | Exclusive Windows patches to install (only used when windows\_update\_mode = 'exclusive\_patches') | `list(string)` | `[]` | no |
| <a name="input_windows_update_mode"></a> [windows\_update\_mode](#input\_windows\_update\_mode) | Windows update mode (classifications, excludes, or exclusive\_patches) | `string` | `"classifications"` | no |
| <a name="input_yum_excludes"></a> [yum\_excludes](#input\_yum\_excludes) | YUM packages to exclude | `list(string)` | `[]` | no |
| <a name="input_yum_minimal"></a> [yum\_minimal](#input\_yum\_minimal) | Install minimal updates | `bool` | `true` | no |
| <a name="input_yum_security"></a> [yum\_security](#input\_yum\_security) | Install security updates only | `bool` | `true` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | List of zones to target | `list(string)` | `[]` | no |
| <a name="input_zypper_categories"></a> [zypper\_categories](#input\_zypper\_categories) | Zypper patch categories | `list(string)` | `[]` | no |
| <a name="input_zypper_excludes"></a> [zypper\_excludes](#input\_zypper\_excludes) | Zypper packages to exclude | `list(string)` | `[]` | no |
| <a name="input_zypper_severities"></a> [zypper\_severities](#input\_zypper\_severities) | Zypper patch severities | `list(string)` | `[]` | no |
| <a name="input_zypper_with_optional"></a> [zypper\_with\_optional](#input\_zypper\_with\_optional) | Install optional patches | `bool` | `false` | no |
| <a name="input_zypper_with_update"></a> [zypper\_with\_update](#input\_zypper\_with\_update) | Install recommended patches | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_os_patching_id"></a> [os\_patching\_id](#output\_os\_patching\_id) | n/a |
| <a name="output_os_patching_name"></a> [os\_patching\_name](#output\_os\_patching\_name) | n/a |
<!-- END_TF_DOCS -->
