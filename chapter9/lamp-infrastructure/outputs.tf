resource "local_file" "ansible_inventory" {
  content = templatefile("templates/inventory.tmpl",
    {
      varnish_ip = libvirt_domain.varnish.network_interface.0.addresses.0
      www1_ip = libvirt_domain.www1.network_interface.0.addresses.0
      www2_ip = libvirt_domain.www2.network_interface.0.addresses.0
      db1_ip = libvirt_domain.db1.network_interface.0.addresses.0
      db2_ip = libvirt_domain.db2.network_interface.0.addresses.0
      memcached_ip = libvirt_domain.memcached.network_interface.0.addresses.0
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
