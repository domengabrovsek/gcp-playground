terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "< 5.0"
    }
  }
}

module "cloud_run" {
  source  = "GoogleCloudPlatform/cloud-run/google"
  version = "~> 0.2.0"

  # Required variables
  service_name = "app-1"
  project_id   = "gcp-competence-group"
  location     = "europe-central2"
  image        = "gcr.io/cloudrun/hello"
  members      = ["allUsers"]
}

# output url of service to terminal
output "url" {
    value = module.cloud_run.service_url
}