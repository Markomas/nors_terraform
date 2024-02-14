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
  name = "nors_pool"
  type = "dir"
  path = "/var/lib/libvirt/images/terraform"
}

module "nors-load-balancer" {
  source = "./module/debian"
  vm_name = "nors-load-balancer"
  pool = libvirt_pool.pool.name
  libvirt_uri = var.libvirt_uri
}

module "nors-lv-db" {
  source = "./module/debian"
  vm_name = "nors-lv-db"
  pool = libvirt_pool.pool.name
  libvirt_uri = var.libvirt_uri
  vm_size = 21474836480
}

module "nors-lv-app-blue" {
  source = "./module/debian"
  vm_name = "nors-app-blue"
  pool = libvirt_pool.pool.name
  libvirt_uri = var.libvirt_uri
}

module "nors-lv-app-green" {
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

    lv-db:
        hosts:
            ${module.nors-lv-db.ip}

    green-lv-app:
        hosts:
            ${module.nors-lv-app-green.ip}

    blue-lv-app:
        hosts:
            ${module.nors-lv-app-blue.ip}

    prod-app:
        children:
            green-lv-app:
            blue-lv-app:
    DOC
  filename = "./nors_news_ansible_inventory.yml"
}
