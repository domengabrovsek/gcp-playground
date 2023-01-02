terraform {
  # specify a required version (= >= ~>)
  required_version = ">= 1.0.11"

  # specify a remote backend
  backend "gcs" {
    bucket = "bucket-name"
    prefix = "folder-name"
  }

  # specify required providers
  required_providers {
    google = {
      sousource = "hashicorp/google"
      version   = ">= 4.5.0"
    }
  }

  # specify experimental features
  experiments = ["some-value"]

  # specify provider specific metadata
  provider_meta "google" {
    key = "value"
  }
}
