variable "project_id" {
    description = "Id of the GCP Project"
    type = string
    default = "confident-key-429822-i1"
}

variable "project_name" {
    description = "Name of the GCP Project"
    type = string
    default = "My First Project"
}

variable "project_region" {
    description = "Region of the GCP Project"
    type = string
    default = "us-east1"
}

output "multiply_function_uri" {
    value = google_cloudfunctions2_function.cf_rng.service_config[0].uri
}

output "gen_random_number_function_uri" {
    value = google_cloudfunctions2_function.cf_rng.service_config[0].uri
}