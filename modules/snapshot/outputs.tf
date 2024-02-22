output "policy" {
  description = "Resource snapshot policy details."
  value       = google_compute_resource_policy.policy
}

output "id" {
  description = "Resource snapshot ID."
  value       = google_compute_resource_policy.policy.id
}

output "self_link" {
  description = "Resource snapshot self-link."
  value       = google_compute_resource_policy.policy.self_link
}
