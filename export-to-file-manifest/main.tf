terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.5.0"
    }

    local = {
      source  = "hashicorp/local"
      version = ">= 2.1.0"
    }
  }
}

variable "vm_names" {
  type    = list(string)
  default = ["vm-1", "vm-2"]
}

module "vm" {
  source  = "./modules/vm"
  vm-name = var.vm_names[count.index]
  count   = length(var.vm_names)
}

resource "local_file" "IPs" {
  filename = "./inventory.csv"
  content  = templatefile("manifest.tftpl", { ip_addrs = module.vm.*.ip })
}
