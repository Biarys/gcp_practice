output "google_project_id" {
  description = "Google Project Id"
  value       = "Current GCP project is set to ${var.project_id}"
}

output "multiply_function_uri" {
  value = google_cloudfunctions2_function.cf_rng.service_config[0].uri
}

output "gen_random_number_function_uri" {
  value = google_cloudfunctions2_function.cf_rng.service_config[0].uri
}