provider "google" {
  credentials = file("credentials/gcp-key.json")
  project     = var.project
  region      = var.region
  zone        = var.zone
}

terraform {
  required_version = ">= 1.0.11"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=4.5.0"
    }
  }
}

module "vm_1" {
  source = "../modules/vm"
  name   = "vm-1"
}

module "vm_2" {
  source = "../modules/vm"
  name   = "vm-2"

  # override machine type
  machine_type = "n2-standard-2"
}