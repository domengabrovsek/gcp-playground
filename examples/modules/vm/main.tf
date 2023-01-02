variable "name" {
  description = "Name of VM"
}

variable "machine_type" {
  default     = "f1-micro"
  description = "Type of VM"
}

resource "google_compute_instance" "vm" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project

  can_ip_forward = false
  network_interface {
    network = "default"
    access_config  {}
  }

  # network tags
  tags = []

  boot_disk {
    initialize_params {
      image = "debian-11-bullseye-v20221102"
    }
  }
}
