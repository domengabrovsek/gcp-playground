terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.5.0"
    }
  }

  # create a new bucket before running this
  # gsutil mb gs://gcp-competence-group-tf-state
  backend "gcs" {
    bucket = "gcp-competence-group-tf-state"
    prefix = "terraform/network"
  }
}

# setup vpc
resource "google_compute_network" "vpc" {
  name                    = "terraform-vpc"
  auto_create_subnetworks = false
}

# setup subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "terraform-subnet"
  region        = "europe-central2"
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

# output subnet name
output "subnet_name" {
  value = google_compute_subnetwork.subnet.name
}
