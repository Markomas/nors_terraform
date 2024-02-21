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
  count = try(var.pool ? 0 : 1, 0)
  name = var.vm_name
  type = "dir"
  path = var.libvirt_pool_path
}


resource "libvirt_volume" "debian-disk-resized" {
  name           = "${var.vm_name}_resized.img"
  pool           = try(var.pool, libvirt_pool.pool.0.name)
  base_volume_id = var.base_image_id
  size           = var.vm_size
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.yml")
  vars = {
    vm_hostname = "${var.vm_name}.local"
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "${var.vm_name}_cloudinit.iso"
  user_data      = data.template_file.user_data.rendered #if you set network user no go
  pool           = try(var.pool, libvirt_pool.pool.0.name)
}

resource "libvirt_domain" "domain-debian" {
  name   = var.vm_name
  memory = var.vm_memory
  vcpu   = var.vm_cpus
  running    = true
  autostart  = true
  qemu_agent = true

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    bridge         = "br0"
    wait_for_lease = true
    mac = var.mac_address
   }

  disk {
    volume_id = libvirt_volume.debian-disk-resized.id
  }
}
