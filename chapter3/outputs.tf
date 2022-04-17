resource "local_file" "ansible_inventory" {
  content = templatefile("templates/inventory.tmpl",
    {
      app1_ip = libvirt_domain.orc-app1.network_interface.0.addresses.0
      app2_ip = libvirt_domain.orc-app2.network_interface.0.addresses.0
      db_ip   = libvirt_domain.orc-db.network_interface.0.addresses.0
    }
  )
  filename = "inventory"
}

resource "local_file" "bash_config" {
  content = templatefile("templates/config.sh.tmpl",
    {
      pvt_key = var.pvt_key
    }
  )
  filename = "config.sh"
}
