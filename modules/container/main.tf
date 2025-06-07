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
    ip     = "${var.proxmox_lxc_ip}/24"
  }
  memory = var.proxmox_lxc_mem
}

# OT*7eOZ2hDPJ4K6F