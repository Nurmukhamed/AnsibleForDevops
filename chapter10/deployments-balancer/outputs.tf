resource "local_file" "ansible_inventory" {
  content = templatefile("templates/inventory.tmpl",
    {
      bal1_ip = libvirt_domain.bal1.network_interface.0.addresses.0
      app1_ip = libvirt_domain.app1.network_interface.0.addresses.0
      app2_ip = libvirt_domain.app2.network_interface.0.addresses.0
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
