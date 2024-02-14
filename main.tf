terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = var.libvirt_uri
}

resource "libvirt_pool" "pool" {
  name = "playground"
  type = "dir"
  path = "/var/lib/libvirt/images/terraform"
}

module "nors-app-blue" {
  source = "./module/debian"
  vm_name = "nors-app-blue"
  pool = libvirt_pool.pool.name
  libvirt_uri = var.libvirt_uri
}

module "nors-app-green" {
  source = "./module/debian"
  vm_name = "nors-app-green"
  pool = libvirt_pool.pool.name
  libvirt_uri = var.libvirt_uri
}
