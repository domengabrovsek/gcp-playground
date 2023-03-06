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
    prefix = "terraform/vm"
  }
}

# create datasource from terraform network backend state
data "terraform_remote_state" "network" {
  backend = "gcs"
  config = {
    prefix = "terraform/network"
    bucket = "gcp-competence-group-tf-state"
  }
}

resource "google_compute_instance" "vm" {
  name         = "terraform-vm"
  machine_type = "f1-micro"
  zone         = "europe-central2-a"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }
  network_interface {
    subnetwork = data.terraform_remote_state.network.outputs.subnet_name
  }
}
