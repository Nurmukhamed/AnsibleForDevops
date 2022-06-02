resource "local_file" "ansible_inventory" {
  content = templatefile("templates/inventory.tmpl",
    {
      ubuntu_ip = libvirt_domain.ubuntu.network_interface.0.addresses.0
      centos7_ip = libvirt_domain.centos7.network_interface.0.addresses.0
     }
  )
  filename = "inventory"
}

resource "local_file" "bash_config" {
  content = templatefile("${path.module}/../../templates/config.sh.tmpl",
    {
      pvt_key = var.pvt_key
    }
  )
  filename = "config.sh"
}
