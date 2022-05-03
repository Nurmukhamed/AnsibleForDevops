resource "libvirt_pool" "ansible" {
  name = "ansible"
  type = "dir"
  path = "/var/lib/libvirt/images/pool-ansible"
}

resource "libvirt_volume" "os_image_centos7" {
  name   = "os_image_centos7"
  pool   = libvirt_pool.ansible.name
#  source = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2"
  source = "${path.module}/../../iso/CentOS-7-x86_64-GenericCloud.qcow2"
  format = "qcow2"
}

data "template_file" "network_config_centos" {
  template = file("${path.module}/../../templates/network_config_centos.cfg.tmpl")
}

# IPs: use wait_for_lease true or after creation use terraform refresh and terraform show for the ips of domain
