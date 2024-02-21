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

resource "libvirt_volume" "debian-base" {
  name   = "debian_base.img"
  pool   = libvirt_pool.pool.name
  source = var.base_img_url
  format = "qcow2"
}

module "nors-load-balancer" {
  source = "./module/debian"
  vm_name = "nors-load-balancer"
  pool = libvirt_pool.pool.name
  libvirt_uri = var.libvirt_uri
  base_image_id = libvirt_volume.debian-base.id
  vm_cpus = 2
  mac_address = "b7:f1:4e:1e:f7:d7"
}

module "nors-lv-db" {
  source = "./module/debian"
  vm_name = "nors-lv-db"
  pool = libvirt_pool.pool.name
  libvirt_uri = var.libvirt_uri
  base_image_id = libvirt_volume.debian-base.id
  vm_size = 21474836480
  vm_cpus = 4
  mac_address = "a6:24:e9:61:99:30"
}

module "nors-lv-db-slave" {
  source = "./module/debian"
  vm_name = "nors-lv-db-slave"
  pool = libvirt_pool.pool.name
  libvirt_uri = var.libvirt_uri
  base_image_id = libvirt_volume.debian-base.id
  vm_size = 21474836480
  vm_cpus = 4
  mac_address = "21:0b:46:32:23:5a"
}

module "nors-lv-app-blue" {
  source = "./module/debian"
  vm_name = "nors-app-blue"
  pool = libvirt_pool.pool.name
  libvirt_uri = var.libvirt_uri
  base_image_id = libvirt_volume.debian-base.id
  vm_cpus = 2
  mac_address = "e3:d1:3e:12:f5:6b"
}

module "nors-lv-app-green" {
  source = "./module/debian"
  vm_name = "nors-app-green"
  pool = libvirt_pool.pool.name
  libvirt_uri = var.libvirt_uri
  base_image_id = libvirt_volume.debian-base.id
  vm_cpus = 2
  mac_address = "e4:c8:c6:8e:99:cb"
}

resource "local_file" "nors_news_ansible_inventory_file" {
  content = <<-DOC
    lv_load_balancer:
        hosts:
           ${module.nors-load-balancer.ip}

    lv_db:
        hosts:
            ${module.nors-lv-db.ip}

    lv_db_slave:
        hosts:
            ${module.nors-lv-db-slave.ip}

    green_lv_app:
        hosts:
            ${module.nors-lv-app-green.ip}

    blue_lv_app:
        hosts:
            ${module.nors-lv-app-blue.ip}

    prod_app:
        children:
            green_lv_app:
            blue_lv_app:
    DOC
  filename = "./nors_news_ansible_inventory.yml"
}
