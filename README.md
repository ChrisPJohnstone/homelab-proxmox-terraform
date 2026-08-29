# Proxmox Homelab

Terraform configuration that provisions my [Proxmox VE](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview) homelab using the [`bpg/proxmox`](https://registry.terraform.io/providers/bpg/proxmox/latest) provider.

## Features

- Provisions & Bootstraps a [Kubernetes](https://kubernetes.io/) cluster.
  - Downloads [Debian](https://debian.org) cloud image to use as base
  - Uses [Cloud-Init](https://cloud-init.io) to provision, static IP per VM, SSH Access & all user configuration.
  - Bootstraps cluster with [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/)
  - [cri-o](https://cri-o.io/) container runtime
  - [flannel](https://github.com/flannel-io/flannel) Container Network Interface (CNI)
  - Configurable number of nodes (see [main.tf](./terraform/main.tf))

## Usage

### Pre-Requisites

- [Terraform](https://developer.hashicorp.com/terraform) Installed
- [Proxmox VE](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview) Set up on a machine

### Set up SSH Agent

This project uses SSH keys to transfer files from the users machine (e.g. cloud-init templates) to the proxmox instance

- Start ssh-agent
  ```sh
  eval "${ ssh-agent -s; }"
  ```
- Generate SSH Key with your email
  ```sh
  ssh-keygen -t {type} -C {email}
  ```
  Example
  ```sh
  ssh-keygen -t ed25519 -C test@test.com
  ```
- Add your key to your agent sesssion
  ```sh
  ssh-add
  ```
- Add your SSH key to proxmox
  ```sh
  ssh-copy-id -i {public_key_file} {username}@{host}
  ```
  Example
  ```sh
  ssh-copy-id -i .ssh/id_ed25519.pub root@1.1.1.1
  ```

### Proxmox Settings

> [!NOTE]
> These commands are intened to be run on the proxmox machine

- Enable content types (snippets is not enabled by default)
  ```sh
  pvesm set local -content backup,iso,vztmpl,import,snippets
  ```

### Generating API Token

This project is built to authenticate with Proxmox using API token.

> [!NOTE]
> These commands for setup are intended to be run on the proxmox machine

- Create user with `PVEAdmin` permissions
  ```sh
  pveum user add {username}@pam
  pveum acl modify / --user {username}@pam --role PVEAdmin
  ```
  Example
  ```sh
  pveum user add terraform@pam
  pveum acl modify / --user terraform@pam --role PVEAdmin
  ```
- Generate token
  ```sh
  pveum user token add {username}@pam {token_name} --privsep 0
  ```
  Example
  ```sh
  pveum user token add terraform@pam tf_token --privsep 0
  ```
- Output will have a UUID value like `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`. This is your token secret
- Full token would look something like
  ```
  {username}@pam!{token_name}={token_secret}
  ```
  Example
  ```
  terraform@pam!tf_token=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  ```

### Update Variables

- Copy [`terraform/.auto.tfvars.dist`](./terraform/.auto.tfvars.dist) to `terraform/.auto.tfvars`
  ```sh
  cp terraform/.auto.tfvars.dist terraform/.auto.tfvars
  ```
- Update the values in `terraform/.auto.tfvars`

### Managing Infrastructure

> [!NOTE]
> [SSH key needs to be `ssh-add`ed to every new session](#set-up-ssh-agent)
>
> All commands should be run from [terraform](./terraform/) directory

- Initialise Terraform
  ```sh
  terraform init
  ```
- Deploy Resources
  ```sh
  terraform apply
  ```
- Destroy Resources
  ```sh
  terraform destroy
  ```
