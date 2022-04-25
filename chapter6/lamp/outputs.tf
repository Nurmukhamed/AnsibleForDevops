resource "local_file" "ansible_inventory" {
  content = templatefile("templates/inventory.tmpl",
    {
      lamp_ip = libvirt_domain.lamp.network_interface.0.addresses.0
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
