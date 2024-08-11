variable "vm_image" {
  description = "The image to use for the virtual machine"
  type        = string
  sensitive   = true
}

variable "ssh_key_source" {
  description = "The source path of the SSH public key"
  type        = string
  sensitive   = true
}

variable "ssh_private_key_path" {
  description = "The path to the SSH private key file"
  type        = string
  sensitive   = true
}

variable "network_adapter" {
  description = "The network adapter to use for the virtual machine"
  type        = string
  sensitive   = true
}
