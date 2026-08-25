# Proxmox Terraform

## Usage

### Pre-Requisites

- [Terraform](https://developer.hashicorp.com/terraform) Installed
- [Proxmox VE](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview) Set up on a machine

### Generating API Token

This project is built to authenticate with Proxmox using API token.

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
> All commands should be run from `terraform` directory

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
