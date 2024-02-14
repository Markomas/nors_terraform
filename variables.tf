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