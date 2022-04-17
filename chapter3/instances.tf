resource "libvirt_pool" "ansible" {
  name = "ansible"
  type = "dir"
  path = "/var/lib/libvirt/images/pool-ansible"
}

# We fetch the latest ubuntu release image from their mirrors
resource "libvirt_volume" "os_image_centos8" {
  name   = "os_image_centos8"
  pool   = libvirt_pool.ansible.name
#  source = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2"
  source = "../iso/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2"
  format = "qcow2"
}

resource "libvirt_volume" "disk_app1" {
  name           = "disk-app1"
  base_volume_id = libvirt_volume.os_image_centos8.id
  pool           = libvirt_pool.ansible.name
#  size           = 5361393152
}

resource "libvirt_volume" "disk_app2" {
  name           = "disk-app2"
  base_volume_id = libvirt_volume.os_image_centos8.id
  pool           = libvirt_pool.ansible.name
#  size           = 5361393152
}

resource "libvirt_volume" "disk_db" {
  name           = "disk-db"
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

data "template_file" "user_data_app2" {
  template = file("${path.module}/templates/cloud_init.cfg.tmpl")
  vars = {
    server_hostname = "orc-app2.test"
  }
}

data "template_file" "user_data_db" {
  template = file("${path.module}/templates/cloud_init.cfg.tmpl")
  vars = {
    server_hostname = "orc-db.test"
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/templates/network_config.cfg.tmpl")
}

resource "libvirt_cloudinit_disk" "commoninit-app1" {
  name           = "commoninit-app1.iso"
  user_data      = data.template_file.user_data_app1.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.ansible.name
}

resource "libvirt_cloudinit_disk" "commoninit-app2" {
  name           = "commoninit-app2.iso"
  user_data      = data.template_file.user_data_app2.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.ansible.name
}

resource "libvirt_cloudinit_disk" "commoninit-db" {
  name           = "commoninit-db.iso"
  user_data      = data.template_file.user_data_db.rendered
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

# Create the machine
resource "libvirt_domain" "orc-app2" {
  name   = "orc-app2"
  memory = "2048"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit-app2.id

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
    volume_id = libvirt_volume.disk_app2.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

# Create the machine
resource "libvirt_domain" "orc-db" {
  name   = "orc-db"
  memory = "2048"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit-db.id

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
    volume_id = libvirt_volume.disk_db.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

# IPs: use wait_for_lease true or after creation use terraform refresh and terraform show for the ips of domain
