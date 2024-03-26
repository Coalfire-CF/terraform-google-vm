output "os_patching_name" {
  value = google_os_config_patch_deployment.yum_patch.name
}

output "os_patching_id" {
  value = google_os_config_patch_deployment.yum_patch.id
}