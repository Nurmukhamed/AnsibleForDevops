resource "null_resource" "cluster" {
  connection {
      host        = libvirt_domain.ubuntu.network_interface.0.addresses.0
      user        = "nartykaly"
      type        = "ssh"
      private_key = "${file("${var.pvt_key}")}"
      timeout     = "2m"
    }

  provisioner "file" {
    source      = "./provisioning"
    destination = "/tmp/provisioning"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/provisioning /vagrant/",
      "sudo chown root:root -R /vagrant/provisioning",
    ]
  } 

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory provisioning/main.yml"
  }

  depends_on = [
   libvirt_domain.ubuntu
  ]
}
