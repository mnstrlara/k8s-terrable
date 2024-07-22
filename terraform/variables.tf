variable "ssh_key_path" {
  description = "Path leading to the SSH key."
  sensitive   = true
}

variable "ssh_public_key_path" {
  description = "Path leading to the Public SSH key."
  sensitive   = true
}

variable "ubuntu_version" {
  description = "The Version of Ubuntu used in the VM"
  default     = "24.04"
}
