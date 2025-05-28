variable "container_os_name" {
    description = "Operating System Name"
    type = string
}
variable "container_os_template" {
    description = "Operating System Template"
    type = string
}
# proxmox api username
variable "proxmox_dc_user" {
  default = "terraform-prov@pve"
  type = string
}
# proxmox api pass
variable "proxmox_dc_pass" {
  default = "9iNDZULn}f;4TT3"
  type = string
}