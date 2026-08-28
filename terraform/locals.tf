locals {
  api_token = "${var.username}@pam!${var.token_name}=${var.secret_key}"
}
