terraform {
  required_providers {
    virtualbox = {
      source  = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }
  }
}

resource "virtualbox_vm" "node" {
  count  = 2
  name   = format("node-%02d-%s", count.index + 1, random_id.vm_id[count.index].hex)
  image  = var.vm_image
  cpus   = 2
  memory = "1024 mib"

  network_adapter {
    type           = "hostonly"
    host_interface = "vboxnet0"
  }

  boot_order = ["disk", "none", "none", "none"]

  # Add provisioner to inject SSH key
  provisioner "file" {
    source      = var.ssh_key_source
    destination = "/home/ubuntu/.ssh/authorized_keys"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/ubuntu/.ssh/authorized_keys /etc/home/ubuntu/.ssh/authorized_keys",
      "sudo hostnamectl set-hostname ${format("node-%02d", count.index + 1)}",
      "sudo netplan apply",
      "ip a s"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_private_key_path)
    host        = self.network_adapter[0].ipv4_address
  }
}

resource "random_id" "vm_id" {
  count       = 2
  byte_length = 4
}
