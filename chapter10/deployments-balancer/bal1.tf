resource "libvirt_volume" "disk_bal1" {
  name           = "disk-bal1"
  base_volume_id = libvirt_volume.os_image_ubuntu.id
  pool           = libvirt_pool.ansible.name
  size           = 5361393152
}

data "template_file" "user_data_bal1" {
  template = file("${path.module}/../../templates/cloud_init_ubuntu.cfg.tmpl")
  vars = {
    server_hostname = "bal1.test"
  }
}

resource "libvirt_cloudinit_disk" "commoninit-bal1" {
  name           = "commoninit-bal1.iso"
  user_data      = data.template_file.user_data_bal1.rendered
  network_config = data.template_file.network_config_ubuntu.rendered
  pool           = libvirt_pool.ansible.name
}

# Create the machine
resource "libvirt_domain" "bal1" {
  name   = "bal1"
  memory = "1024"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit-bal1.id

  network_interface {
    network_name = "default"
    wait_for_lease = true
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.disk_bal1.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  provisioner "remote-exec" {
    connection {
      host        = self.network_interface.0.addresses.0
      user        = "nartykaly"
      type        = "ssh"
      private_key = "${file("${var.pvt_key}")}"
      timeout     = "2m"
    }

    inline = [
      "while [ ! -f /tmp/cloud-init.txt ]; do sleep 2; done;",
    ]
  }
}

# IPs: use wait_for_lease true or after creation use terraform refresh and terraform show for the ips of domain
