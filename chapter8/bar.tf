resource "libvirt_volume" "disk_bar" {
  name           = "disk-bar"
  base_volume_id = libvirt_volume.os_image_ubuntu.id
  pool           = libvirt_pool.ansible.name
  size           = 5361393152
}

data "template_file" "user_data_bar" {
  template = file("${path.module}/../templates/cloud_init_ubuntu.cfg.tmpl")
  vars = {
    server_hostname = "bar.test"
  }
}

resource "libvirt_cloudinit_disk" "commoninit-bar" {
  name           = "commoninit-bar.iso"
  user_data      = data.template_file.user_data_bar.rendered
  network_config = data.template_file.network_config_ubuntu.rendered
  pool           = libvirt_pool.ansible.name
}

# Create the machine
resource "libvirt_domain" "bar" {
  name   = "bar"
  memory = "2048"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit-bar.id

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
    volume_id = libvirt_volume.disk_bar.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

# IPs: use wait_for_lease true or after creation use terraform refresh and terraform show for the ips of domain
