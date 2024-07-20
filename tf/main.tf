terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.38.0"
    }
  }
}

provider "google" {
  project = var.project_id
}

resource "google_project" "my_project" {
  name       = var.project_name
  project_id = var.project_id
}
