variable "base_img_url" {
  description = "URL to debian cloud img qcow2"
  type        = string
  default     = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
}

variable "libvirt_uri" {
  description = "libvirt_uri"
  type        = string
  default     = "qemu+ssh://markomasas@homelab.lt/system?known_hosts_verify=ignore"
}

variable "pool" {
  description = "libvirt pool name"
  type        = string
}

variable "libvirt_pool_path" {
  description = "Libvirt poll dir path"
  type        = string
  default     = "/var/lib/libvirt/images/terraform"
}

variable "vm_name" {
  description = "Name of the VM"
  type        = string
  default     = "terraform"
}

variable "vm_size" {
  description = "Size of the VM"
  type        = number
  default     = 5361393664
}

variable "vm_memory" {
  description = "Memory of the VM"
  type        = number
  default     = 1024
}

variable "vm_cpus" {
  description = "CPUs of the VM"
  type        = number
  default     = 1
}

variable "base_image_id" {
  description = "ID of the base image, if set base_image_url will be ignored"
  type        = string
  default     = ""
}