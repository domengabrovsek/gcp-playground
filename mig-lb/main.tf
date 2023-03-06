# cloud provider specific info
provider "google" {
  credentials = file("credentials/gcp-key.json")
  project     = var.project
  region      = var.region
  zone        = var.zone
}

# cloud storage bucket for terrafrom state
resource "google_storage_bucket" "tf-state-bucket" {
  name          = "domen-gabrovsek-bucket-tfstate"
  force_destroy = false
  location      = "EU"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

# terraform backend (store state in cloud storage)
terraform {
  backend "gcs" {
    # bucket name
    bucket = "domen-gabrovsek-bucket-tfstate"
    # folder name
    prefix = "tf-state-test"
    # credentials for gcp
    credentials = "credentials/gcp-key.json"
  }
}

# VPC
resource "google_compute_network" "gcp-cg-tf-network-domen" {
  name = "gcp-cg-tf-network-domen"
}

# firewall
resource "google_compute_firewall" "gcp-cg-tf-firewall-domen" {
  name    = "gcp-cg-tf-firewall-domen"
  network = google_compute_network.gcp-cg-tf-network-domen.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gcp-cg-tf-network"]
}

# autoscaler for managed instance group
resource "google_compute_autoscaler" "gcp-cg-tf-autoscaler-domen" {
  name    = "gcp-cg-tf-autoscaler-domen"
  project = var.project
  zone    = var.zone
  target  = google_compute_instance_group_manager.gcp-cg-tf-instance-group-domen.self_link

  autoscaling_policy {
    max_replicas    = 2
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}

# instance template
resource "google_compute_instance_template" "gcp-cg-tf-instance-template-domen" {
  name           = "gcp-cg-tf-template-domen"
  machine_type   = "f1-micro"
  can_ip_forward = false
  project        = var.project

  # network tags (used for firewall)
  tags = ["gcp-cg-tf-network", "http-server"]

  disk {
    source_image = "debian-11-bullseye-v20221102"
  }

  network_interface {
    network = google_compute_network.gcp-cg-tf-network-domen.name

    # an external IP is created because of this
    access_config {}
  }

  # script to run on boot
  metadata_startup_script = file("startup.sh")
}

# reserved IP address
resource "google_compute_global_address" "gcp-cg-tf-ip" {
  name = "gcp-cg-tf-ip"
}

# health check
resource "google_compute_http_health_check" "gcp-cg-tf-health-check-domen" {
  name                = "gcp-cg-tf-health-check-domen"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds
  request_path        = "/"
}

# target pool
resource "google_compute_target_pool" "gcp-cg-tf-target-pool-domen" {
  name = "gcp-cg-tf-target-pool-domen"

  health_checks = [
    google_compute_http_health_check.gcp-cg-tf-health-check-domen.name,
  ]
}

# forwarding rule
resource "google_compute_forwarding_rule" "gcp-cg-tf-forwarding-rule-domen" {
  name                = "gcp-gc-tf-forwarding-rule-domen"
  target              = google_compute_target_pool.gcp-cg-tf-target-pool-domen.self_link
  region              = var.region
  ip_protocol         = "TCP"
}

# managed instance group
resource "google_compute_instance_group_manager" "gcp-cg-tf-instance-group-domen" {
  name         = "gcp-cg-tf-instance-group-domen"
  zone         = var.zone
  project      = var.project
  target_pools = [google_compute_target_pool.gcp-cg-tf-target-pool-domen.id]

  # instance template to use
  version {
    instance_template = google_compute_instance_template.gcp-cg-tf-instance-template-domen.self_link
    name              = "primary"
  }

  # prefix for names of VMs
  base_instance_name = "gcp-cg-tf-domen"
}
