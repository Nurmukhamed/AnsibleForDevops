resource "local_file" "ansible_inventory" {
  content = templatefile("templates/inventory.tmpl",
    {
      foo_ip = libvirt_domain.foo.network_interface.0.addresses.0
      bar_ip = libvirt_domain.bar.network_interface.0.addresses.0
    }
  )
  filename = "inventory"
}

resource "local_file" "python_inventory" {
  content = templatefile("templates/inventory.py.tmpl",
    {
      foo_ip = libvirt_domain.foo.network_interface.0.addresses.0
      bar_ip = libvirt_domain.bar.network_interface.0.addresses.0
    }
  )
  filename = "inventory.py"
}

resource "local_file" "bash_config" {
  content = templatefile("${path.module}/../templates/config.sh.tmpl",
    {
      pvt_key = var.pvt_key
    }
  )
  filename = "config.sh"
}
