# Proxmox Terraform

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
  ssh-keygen -t ed25519 -C {email}
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
  ssh-copy-id -i .ssh/id_ed25519.pub {username}@{host}
  ```
  Example
  ```sh
  ssh-copy-id -i .ssh/id_ed25519.pub root@1.1.1.1
  ```

### Generating API Token

This project is built to authenticate with Proxmox using API token.

> [!NOTE]
> Setting up the proxmox user needs to be done on the proxmox machine

- Create user `terraform` with `PVEAdmin` permissions
  ```sh
  pveum user add terraform@pam
  pveum acl modify / --user terraform@pam --role PVEAdmin
  ```
- Generate token name `tf_token` for user `terraform`
  ```sh
  pveum user token add terraform@pam tf_token --privsep 0
  ```
- Output will have a UUID value like `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`. This is your token secret
- Full token should look something like
  ```
  {username}@pam!{token_name}={token_secret}
  ```
  For Example
  ```
  terraform@pam!tf_token=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  ```

### Update Variables

- Copy [terraform/.auto.tfvars.dist](./terraform/.auto.tfvars.dist) to `terraform/.auto.tfvars`
  ```sh
  cp terraform/.auto.tfvars.dist terraform/.auto.tfvars
  ```
- Update the values in `terraform/.auto.tfvars`

### Managing Infrastructure

> [!NOTE]
> [SSH key needs to be added to every new session](#set-up-ssh-agent)
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
