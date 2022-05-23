resource "local_file" "ansible_inventory" {
  content = templatefile("templates/inventory.tmpl",
    {
      nodejs1_ip = libvirt_domain.nodejs1.network_interface.0.addresses.0
      nodejs2_ip = libvirt_domain.nodejs2.network_interface.0.addresses.0
      nodejs3_ip = libvirt_domain.nodejs3.network_interface.0.addresses.0
      nodejs4_ip = libvirt_domain.nodejs4.network_interface.0.addresses.0
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
