module "container" {
  source = "../modules/container"
  container_os_name = "coredns"
  container_os_template = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  proxmox_lxc_ip = "192.168.1.200"
  ssh_key = var.ssh_key
}


module "container_gitlab" {
  source = "../modules/container"
  container_os_name = "gitlab"
  container_os_template = "local:vztmpl/debian-12-turnkey-gitlab_18.1-1_amd64.tar.gz"
  proxmox_lxc_ip = "192.168.1.201"
  proxmox_lxc_mem = "4096"
  ssh_key = var.ssh_key
}
