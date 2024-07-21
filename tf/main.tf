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
  region = var.project_region
}

resource "google_storage_bucket" "default" {
  name                        = "gcp-practice-cfs-gcf-source" # Every bucket name must be globally unique
  location                    = "US"
  uniform_bucket_level_access = true
}

data "archive_file" "cf_rng_archive" {
  type        = "zip"
  output_path = "/tmp/function-random-number-gen.zip"
  source_dir  = "../function_random_number_gen/"
}

resource "google_storage_bucket_object" "object_rng" {
  name   = "function-random-number-gen.zip"
  bucket = google_storage_bucket.default.name
  source = data.archive_file.cf_rng_archive.output_path # Add path to the zipped function source code
}

resource "google_cloudfunctions2_function" "cf_rng" {
  name        = "gen-random-num-function-v2"
  location    = var.project_region
  description = "Generate random number function"

  build_config {
    runtime     = "python312"
    entry_point = "randomgen" # Set the entry point
    source {
      storage_source {
        bucket = google_storage_bucket.default.name
        object = google_storage_bucket_object.object_rng.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 60
  }
}


data "archive_file" "cf_multiply_archive" {
  type        = "zip"
  output_path = "/tmp/function-random-number-gen.zip"
  source_dir  = "../function_multiply_number/"
}

resource "google_storage_bucket_object" "object_multiply" {
  name   = "function-multiply-number.zip"
  bucket = google_storage_bucket.default.name
  source = data.archive_file.cf_multiply_archive.output_path # Add path to the zipped function source code
}

resource "google_cloudfunctions2_function" "cf_multiply" {
  name        = "multiply-num-function-v2"
  location    = var.project_region
  description = "Multiplies supplied number function"

  build_config {
    runtime     = "python312"
    entry_point = "multiply" # Set the entry point
    source {
      storage_source {
        bucket = google_storage_bucket.default.name
        object = google_storage_bucket_object.object_multiply.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 60
  }
}


resource "google_cloud_run_service_iam_member" "member" {
  location = google_cloudfunctions2_function.cf_rng.location
  service  = google_cloudfunctions2_function.cf_rng.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_artifact_registry_repository" "my-repo" {
  location      = var.project_region
  repository_id = "my-repository"
  description   = "example docker repository"
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }
}