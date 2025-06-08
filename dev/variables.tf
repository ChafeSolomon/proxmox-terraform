# proxmox api username
variable "proxmox_dc_user" {
  default = "terraform-prov@pve"
  type = string
}
# proxmox api pass
variable "proxmox_dc_pass" {
  default = ""
  type = string
}
variable "ssh_key" {
  type = string
}