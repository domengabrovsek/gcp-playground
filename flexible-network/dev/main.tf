terraform {
  required_version = ">= 1.0.11"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.5.0"
    }
  }
}

module "network" {
  source      = "../modules/network"
  environment = "dev"
  cidr_range  = "10.10.0.0/24"
  regions     = ["europe-central2", "europe-west1"]
  subnet_size = 28
}
