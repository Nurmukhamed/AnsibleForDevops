resource "local_file" "ansible_inventory" {
  content = templatefile("templates/inventory.tmpl",
    {
      drupal_ip = libvirt_domain.drupal.network_interface.0.addresses.0
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
