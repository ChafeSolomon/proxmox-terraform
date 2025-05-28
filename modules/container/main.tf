resource "proxmox_lxc" "basic" {
  target_node  = "proxmox"
  hostname     = var.container_os_name
  ostemplate   = var.container_os_template
  password     = "BasicLXCContainer"
  unprivileged = true

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
  }
}
