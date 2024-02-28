output "instances_details" {
  description = "List of all details for compute instances"
  value       = google_compute_instance.compute_instance.*
  sensitive   = true
}

output "name" {
  description = "Name of instance."
  value       = google_compute_instance.compute_instance.*.name
}

output "id" {
  description = "ID of instance."
  value       = google_compute_instance.compute_instance.*.id
}

output "instance_id" {
  description = "Server-assigned unique identifier of this instance."
  value       = google_compute_instance.compute_instance.*.instance_id
}

output "self_link" {
  description = "Self-link of the instance."
  value       = google_compute_instance.compute_instance.*.self_link
}

output "status" {
  description = "Current status of the instance."
  value       = google_compute_instance.compute_instance.*.current_status
}

output "zone" {
  description = "Zone that the instance is located in."
  value       = google_compute_instance.compute_instance.*.zone
}

output "labels" {
  description = "Labels that will be associated with the instance."
  value       = google_compute_instance.compute_instance.*.labels
}

output "tags" {
  description = "Tags that will be associated with the instance."
  value       = google_compute_instance.compute_instance.*.tags
}

output "private_ip" {
  description = "Private IP address assigned to the instance."
  value       = google_compute_instance.compute_instance.*.network_interface.0.network_ip
}

output "public_ip" {
  description = "Public IP address assigned to the instance."
  value       = try(google_compute_instance.compute_instance.*.network_interface.0.access_config.0.nat_ip, null)
}

output "image" {
  description = "Self-link of the image."
  value       = google_compute_instance.compute_instance.*.boot_disk.0.initialize_params.0.image
}

output "service_account" {
  description = "Service account attached to the instance."
  value       = google_compute_instance.compute_instance.*.service_account.0.email
}
