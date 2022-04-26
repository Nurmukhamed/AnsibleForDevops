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
  source = "${path.module}/../iso/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2"
  format = "qcow2"
}

data "template_file" "network_config" {
  template = file("${path.module}/../templates/network_config_centos.cfg.tmpl")
}

# IPs: use wait_for_lease true or after creation use terraform refresh and terraform show for the ips of domain
