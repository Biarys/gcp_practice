terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.38.0"
    }
  }
}


resource "google_project" "my_project" {
  provider = google.my_project
  name       = "gcp-practice"
  project_id = "gcp-practice-test-1"
}


provider "google" {
  alias = "my_project"
}


data "google_project" "current_project" {
  provider = google

  depends_on = [
    google_project.my_project
  ]
}

provider "google" {
  project = google_project.my_project.project_id
}

output "google_project_id" {
  description = "Google Project Id"
  value       = data.google_project.current_project.project_id
}