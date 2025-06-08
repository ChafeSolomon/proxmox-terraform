terraform {  
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc9"
    }
  }
}

provider "proxmox" {
  pm_user = var.proxmox_dc_user
  pm_password = var.proxmox_dc_pass
  pm_api_url = "http://192.168.1.232:8006/api2/json"
  pm_tls_insecure = true # By default Proxmox Virtual Environment uses self-signed certificates.
}