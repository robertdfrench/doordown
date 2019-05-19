resource "triton_machine" "host" {
  name        = "doordown"
  package     = "g4-highcpu-128M"
  networks    = ["${data.triton_network.public.id}"]
  image       = "${data.triton_image.smartos.id}"
  user_script = "${file("provision.sh")}"
}

data "triton_network" "public" {
  name = "Joyent-SDC-Public"
}

output "host_ip" {
  value = "${triton_machine.host.primaryip}"
}
