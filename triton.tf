variable "triton_account" {}
variable "triton_key_id" {}

provider "triton" {
  account = "${var.triton_account}"
  key_id  = "${var.triton_key_id}"
}
