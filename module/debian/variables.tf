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
  description = "ID of the base image"
  type        = string
}

variable "mac_address" {
  description = "MAC address of the VM"
  type        = string
}
