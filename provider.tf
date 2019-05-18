variable "provider_account" {}
variable "provider_key_id" {}

provider "triton" {
  account = "${var.provider_account}"
  key_id  = "${var.provider_key_id}"
}
