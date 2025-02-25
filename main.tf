resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  for_each    = toset(concat([for node in range(1) : "node${node}"]))
  name        = each.value
  node_name = "proxmox"

  # should be true if qemu agent is not installed / enabled on the VM
  stop_on_destroy = true

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 10
  }

  initialization {
    user_account {
      # do not use this in production, configure your own ssh key instead!
      username = "proxmox"
      password = "password"
    }
    dns {
      servers = ["8.8.8.8", "1.1.1.1"]
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge = "vmbr0"
  }
}
resource "proxmox_virtual_environment_vm" "nfs_vm" {
  name        = "NFS"
  node_name = "proxmox"

  # should be true if qemu agent is not installed / enabled on the VM
  stop_on_destroy = true

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 120
  }

  initialization {
    user_account {
      # do not use this in production, configure your own ssh key instead!
      username = "proxmox"
      password = "password"
    }
    dns {
      servers = ["8.8.8.8", "1.1.1.1"]
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge = "vmbr0"
  }
}
resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "proxmox"
  url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

