resource "libvirt_volume" "disk_app1" {
  name           = "disk-app1"
  base_volume_id = libvirt_volume.os_image_centos8.id
  pool           = libvirt_pool.ansible.name
#  size           = 5361393152
}

data "template_file" "user_data_app1" {
  template = file("${path.module}/templates/cloud_init.cfg.tmpl")
  vars = {
    server_hostname = "orc-app1.test"
  }
}

resource "libvirt_cloudinit_disk" "commoninit-app1" {
  name           = "commoninit-app1.iso"
  user_data      = data.template_file.user_data_app1.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.ansible.name
}

# Create the machine
resource "libvirt_domain" "orc-app1" {
  name   = "orc-app1"
  memory = "2048"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit-app1.id

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
    volume_id = libvirt_volume.disk_app1.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

# IPs: use wait_for_lease true or after creation use terraform refresh and terraform show for the ips of domain
