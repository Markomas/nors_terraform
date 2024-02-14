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

module "nors-load-balancer" {
  source = "./module/debian"
  vm_name = "nors-load-balancer"
  pool = libvirt_pool.pool.name
  libvirt_uri = var.libvirt_uri
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

resource "local_file" "nors_news_ansible_inventory_file" {
  content = <<-DOC
    lv-load-balancer:
        hosts:
           ${module.nors-load-balancer.ip}

    green-lv-app:
        hosts:
            ${module.nors-app-green.ip}

    blue-lv-app:
        hosts:
            ${module.nors-app-blue.ip}

    prod-app:
        children:
            green-lv-app:
            blue-lv-app:
    DOC
  filename = "./nors_news_ansible_inventory.yml"
}
