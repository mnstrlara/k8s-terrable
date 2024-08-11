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
    type = "bridged"
    host_interface = var.network_adapter
  }

  boot_order = ["disk", "none", "none", "none"]

  # Add provisioner to inject SSH key
  provisioner "file" {
    source      = var.ssh_key_source
    destination = "/tmp/authorized_keys"
  }
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/vagrant/.ssh",
      "echo '${file(var.ssh_key_source)}' > /home/vagrant/.ssh/authorized_keys",
      "chmod 700 /home/vagrant/.ssh",
      "chmod 600 /home/vagrant/.ssh/authorized_keys",
      "chown -R vagrant:vagrant /home/vagrant/.ssh",
      "sed -i '/vagrant insecure public key/d' /home/vagrant/.ssh/authorized_keys"
    ]
  }

  connection {
    type        = "ssh"
    user        = "vagrant"
    private_key = file("~/.vagrant.d/insecure_private_key")
    host        = self.network_adapter[0].ipv4_address
  }
}

resource "random_id" "vm_id" {
  count       = 2
  byte_length = 4
}
