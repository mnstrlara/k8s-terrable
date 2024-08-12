# k8s-terrable

## Overview:
This project automates the deployment of a Kubernetes cluster using Ansible, Terraform and VirtualBox. It provides a simple and reproducible way to set up a local Kubernetes environment for development and testing purposes.

> **NOTE: This project is an inspiration from the Kraven Security blog: "How to Create a Local Kubernetes Cluster: Terraform and Ansible" that will be linked at the end of the README.md file.**
## Components:

#### 1. VirtualBox:
   - What: A virtualization platform for creating and managing virtual machines.
   - Why: Used to create the virtual machines that will host our Kubernetes cluster, providing isolation and reproducibility.

#### 2. Terraform:
   - What: An Infrastructure as Code (IaC) tool for defining and provisioning infrastructure.
   - Why: Used to define and create the virtual machines in VirtualBox, ensuring consistent and repeatable infrastructure setup.

#### 3. Ansible:
   - What: An automation tool for configuration management and application deployment.
   - Why: Used to configure the virtual machines, install necessary software, and set up the Kubernetes cluster.

#### 4. Kubernetes:
   - What: An open-source container orchestration platform.
   - Why: The target system we're deploying, providing a platform for managing containerized applications at scale.

## Pre-requisites:
- VirtualBox installed on local machine
- Ansible installed on local machine
- Terraform installed on local machine

## Steps:
### 1. Create SSH Key

1. Open a terminal on your local machine.

2. Generate a new SSH key pair:
   ```
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```

3. When prompted, press Enter to accept the default file location (`~/.ssh/id_rsa`).

4. Enter a secure passphrase when prompted (or press Enter for no passphrase).

5. Your new SSH key pair is now generated and saved in the `~/.ssh` directory.

### 2. Terraform Setup

1. Create a `main.tf` file with the following content:
   ```hcl
   terraform {
     required_providers {
       virtualbox = {
         source = "terra-farm/virtualbox"
         version = "0.2.2-alpha.1"
       }
     }
   }

   provider "virtualbox" {
     # Configuration options
   }
   ```

2. Define your VirtualBox resources in the `main.tf` file. For example:
   ```hcl
   resource "virtualbox_vm" "node" {
     count     = 3
     name      = "node-${count.index + 1}"
     image     = "path/to/your/ubuntu.iso"
     cpus      = 2
     memory    = "2048 mib"
     
     network_adapter {
       type           = "bridged"
       host_interface = "en0"
     }
   }
   ```

3. Initialize and apply the Terraform configuration:
   ```
   terraform init
   terraform apply
   ```

This setup uses the `terra-farm/virtualbox` provider to create and manage VirtualBox VMs through Terraform. Adjust the VM specifications and network settings as needed for your Kubernetes cluster.


### 3. Ansible Setup

1. Create an `ansible.cfg` file in your project directory with the following content:
   ```ini
   [defaults]
   inventory = ./inventory
   host_key_checking = False
   ```

2. Create an inventory file named `inventory` to store the host information from Terraform outputs:
   ```ini
   [nodes]
   node1 ansible_host=<IP_ADDRESS_1>
   node2 ansible_host=<IP_ADDRESS_2>
   node3 ansible_host=<IP_ADDRESS_3>
   ```
   Replace `<IP_ADDRESS_X>` with the actual IP addresses obtained from Terraform outputs.

3. Create a `vars.yaml` file to store variables for your Ansible playbook:
   ```yaml
   ---
   ansible_user: vagrant
   ansible_ssh_private_key_file: ~/.ssh/id_rsa
   kind_version: "v0.20.0"
   kubectl_version: "v1.27.3"
   ```

4. Create an Ansible playbook named `k8s_deploy.yaml` for setting up the Kubernetes cluster:
   ```yaml
   ---
   - hosts: nodes
     become: true
     vars_files:
       - vars.yaml

     tasks:
       # Include tasks for installing Docker, Kind, and kubectl
       # (You can refer to the context provided earlier for these tasks)

   ```

5. Running the Ansible playbook should look something like this:
   ```
   ansible-playbook -i inventory k8s_deploy.yaml --extra-vars "@vars.yaml"
   ```

This setup uses a static inventory file to store host information from Terraform outputs, configures Ansible to use this inventory, and sets up the necessary files for running the Ansible playbook to deploy the Kubernetes cluster. The `--extra-vars` option is used to include variables from the `vars.yaml` file.


### 4. Verify Cluster Setup and Functionality

1. SSH into the first node:
   ```
   ssh vagrant@<IP_ADDRESS_1>
   ```

2. Check if Docker is installed:
   ```
   docker --version
   ```

3. Check if Kind is installed:
   ```
   kind --version
   ```

4. Test the cluster:
   ```
   kubectl get nodes
   ```

If everything is set up correctly, you should see the nodes in the cluster. Now you can start deploying your applications to the cluster.

## Documentation:
#### [How to Create a Local Kubernetes Cluster: Terraform and Ansible](https://kravensecurity.com/creating-local-kubernetes-cluster/) - The blog responsible for the idea of this project.
#### [VirtualBox installation](https://www.virtualbox.org/wiki/Downloads) - This link leads to a VirtualBox installation.
#### [Terraform installation](https://developer.hashicorp.com/terraform/install) - This link leads to a Terraform installation.
#### [Ansible installation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) - This link leads to a guide to install Ansible.
#### [VirtualBox provider for Terraform](https://registry.terraform.io/providers/terra-farm/virtualbox/latest/docs) - This link leads to a guide to install the VirtualBox provider for Terraform.