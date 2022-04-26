resource "libvirt_volume" "disk_drupal" {
  name           = "disk-drupal"
  base_volume_id = libvirt_volume.os_image_ubuntu.id
  pool           = libvirt_pool.ansible.name
  size           = 5361393152
}

data "template_file" "user_data_drupal" {
  template = file("${path.module}/../../templates/cloud_init_ubuntu.cfg.tmpl")
  vars = {
    server_hostname = "drupal.test"
  }
}

resource "libvirt_cloudinit_disk" "commoninit-drupal" {
  name           = "commoninit-drupal.iso"
  user_data      = data.template_file.user_data_drupal.rendered
  network_config = data.template_file.network_config_ubuntu.rendered
  pool           = libvirt_pool.ansible.name
}

# Create the machine
resource "libvirt_domain" "drupal" {
  name   = "drupal"
  memory = "2048"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit-drupal.id

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
    volume_id = libvirt_volume.disk_drupal.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

# IPs: use wait_for_lease true or after creation use terraform refresh and terraform show for the ips of domain
