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
  environment = "prod"
  cidr_range  = "10.10.0.0/8"
  regions     = ["europe-central2", "europe-west1", "europe-north1"]
  subnet_size = 24
}
