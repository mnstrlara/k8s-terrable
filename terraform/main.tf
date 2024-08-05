terraform {
  required_providers {
    virtualbox = {
      source  = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }
  }
}

resource "virtualbox_vm" "node" {
  count     = 2
  name      = format("node-%02d-%s", count.index + 1, random_id.vm_id[count.index].hex)
  image     = var.vm_image
  cpus      = 2
  memory    = "1024 mib"

  network_adapter {
    type           = "hostonly"
    host_interface = "vboxnet0"  
  }
}

resource "random_id" "vm_id" {
  count       = 2
  byte_length = 4
}
