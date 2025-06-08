resource "proxmox_lxc" "basic" {
  target_node  = "proxmox"
  hostname     = var.container_os_name
  ostemplate   = var.container_os_template
  password     = "BasicLXCContainer"
  unprivileged = true
  start = true
  
  ssh_public_keys = <<-EOT
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDjk2nLGrl5JdbNDIpLcp1mDP+RX7T+S16iLQ2X1T2WcmjkBzW9/JokAS8z6QMeUVFjNzk44OQ0YHooZDUs0DLk5zsa5TiqKrvGT903s1sCKzm0gEXvNK7ImpGlKoFEGZnsSWLXM36Vacnh9EJweu/45y9w7I+8fXkYZuN91pph4LoO93vcsLs4pujy64T16TjlIYSnYQmovxWiirBoMvwJpL2QqAzCVfviQRQa8Qf65olhWxUJ/0PX/Tj56Et1g6ily64nw0/vD4N1pu9WHpgL0WwT9RX36/cZOPFOK6sOSq5kys9ouhL3h2KIVb+F02OKFsDSO9KVb+nv0woIFltnIKbm+H0i2BRE4+WjClWXMcfZgryhzx6rFTKBjRUeK+JMRu3NHB7N4LwW6IxqCev0UgSRmYlYjUSXnAEq38uv89zHEqkJt8hKi0DXj9oBFaCU+UjoVNpR7kQMYPXmM5MLFFAF73gC+vhiRr0XpQVDMSkEuk1xG+YM3m515cvgOh8= wafe@Chafes-MBP.lan
  EOT
  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "${var.proxmox_lxc_ip}/24"
    gw = "192.168.1.1"
  }
  memory = var.proxmox_lxc_mem
    provisioner "remote-exec" {
    # It's crucial to wait for SSH to be ready.
    # This 'sleep' is a simple but not foolproof way.
    # A 'local-exec' pre-provisioner with a `wait-for-it.sh` or `nc -z` is better.
    # For now, let's include a long sleep.
    # Alternatively, you could add `triggers` to a `null_resource` to run this
    # after the container IP is assigned and then use a `local-exec` to poll.
    # For demonstration, we'll put it directly here.
    inline = [
      "echo 'Waiting 30 seconds for SSH to stabilize...'",
      "sleep 30", # Give SSH time to start up properly after container creation

      # Update Apt Repo
      "sudo apt-get update -y",

      # Turn on root login for SSH
      # First, ensure that /etc/ssh/sshd_config exists and is writable.
      # PerminLogin needs to be 'yes'
      "sudo sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config",
      "sudo sed -i 's/^PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config",
      "sudo sed -i 's/^PermitRootLogin forced-commands-only/PermitRootLogin yes/' /etc/ssh/sshd_config",
      "sudo sed -i 's/^PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config", # Ensure 'no' is also changed

      # Ensure PasswordAuthentication is enabled if you plan to use password login
      # "sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config",
      # "sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config",

      # Install Ansible
      "sudo apt-get install -y software-properties-common", # Often needed for add-apt-repository
      "sudo apt-add-repository --yes --update ppa:ansible/ansible", # Add Ansible PPA
      "sudo apt-get install -y ansible",

      # Restart sshd service
      "sudo systemctl restart sshd",

      "echo 'Remote setup complete!'"
    ]

    connection {
      type        = "ssh"
      user        = "root" # Assuming root access or a user with sudo privileges
      private_key = file("~/.ssh/id_rsa") # Path to your SSH private key on the Terraform host
      host        = var.proxmox_lxc_ip
      timeout     = "5m" # Increase timeout if scripts are long or connection is slow
    }
  }

}

