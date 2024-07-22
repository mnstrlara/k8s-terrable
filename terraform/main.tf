provider "virtualbox" {}

resource "virtualbox_vm" "master" {
  name      = "master"
  desc      = "Master Node"
  image     = var.ubuntu_version
  cpus      = 2
  memory    = 2048
  disk_size = 10000
  network_adapter {
    type = "bridged"
  }

  provisioner "file" {
    source      = "install_k3s.sh"
    destination = "/tmp/install_k3s.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_k3s.sh",
      "/tmp/install_k3s.sh"
    ]

    connection {
      type        = "ssh"
      user        = "your-username" # Replace with your actual username
      private_key = file("~/.ssh/id_rsa")
      host        = self.network_adapter[0].ipv4_address
    }
  }
}

# Variables for SSH connection and other settings
variable "ssh_user" {
  description = "The SSH user to connect to the VM"
  type        = string
  default     = "ubuntu"
}

variable "ssh_private_key" {
  description = "Path to the private SSH key"
  type        = string
  default     = var.ssh_key_path
}

variable "ssh_public_key" {
  description = "Path to the public SSH key"
  type        = string
  default     = var.ssh_public_key_path
}
