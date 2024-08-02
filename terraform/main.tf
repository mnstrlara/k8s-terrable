terraform {
  required_providers {
    virtualbox = {
      source  = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }
  }
}

resource "virtualbox_vm" "node" {
  count     = 1
  name      = format("node-%02d", count.index + 1)
  image     = var.vm_image
  cpus      = 2
  memory    = "1024 mib"

  network_adapter {
    type           = "hostonly"
    host_interface = "vboxnet0"  
  }

  boot_order = ["disk", "none", "none", "none"]
}
