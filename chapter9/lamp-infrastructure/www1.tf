resource "libvirt_volume" "disk_www1" {
  name           = "disk-www1"
  base_volume_id = libvirt_volume.os_image_centos7.id
  pool           = libvirt_pool.ansible.name
#  size           = 5361393152
}

data "template_file" "user_data_www1" {
  template = file("${path.module}/../../templates/cloud_init_centos7.cfg.tmpl")
  vars = {
    server_hostname = "www1.test"
  }
}

resource "libvirt_cloudinit_disk" "commoninit-www1" {
  name           = "commoninit-www1.iso"
  user_data      = data.template_file.user_data_www1.rendered
  network_config = data.template_file.network_config_centos.rendered
  pool           = libvirt_pool.ansible.name
}

# Create the machine
resource "libvirt_domain" "www1" {
  name   = "www1"
  memory = "1024"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit-www1.id

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
    volume_id = libvirt_volume.disk_www1.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

# IPs: use wait_for_lease true or after creation use terraform refresh and terraform show for the ips of domain
