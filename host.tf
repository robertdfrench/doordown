output "host_ip" {
  value = "${triton_machine.host.primaryip}"
}

resource "triton_machine" "host" {
  name        = "doordown"
  package     = "g4-highcpu-128M"
  networks    = ["${data.triton_network.host.id}"]
  image       = "${data.triton_image.host.id}"
  user_script = "${file("provision.sh")}"
}

data "triton_network" "host" {
  name = "Joyent-SDC-Public"
}

data "triton_image" "host" {
  name    = "base-64"
  version = "18.3.0"
}
