resource "libvirt_pool" "ansible" {
  name = "ansible"
  type = "dir"
  path = "/var/lib/libvirt/images/pool-ansible"
}

# We fetch the latest ubuntu release image from their mirrors
resource "libvirt_volume" "os_image_ubuntu" {
  name   = "os_image_ubuntu"
  pool   = libvirt_pool.ansible.name
#  source = "https://cloud-images.ubuntu.com/releases/hirsute/release/ubuntu-20.04-server-cloudimg-amd64-disk-kvm.img"
  source = "${path.module}/../../iso/ubuntu-20.04-server-cloudimg-amd64-disk-kvm.img"
}

data "template_file" "network_config_ubuntu" {
  template = file("${path.module}/../../templates/network_config_ubuntu.cfg.tmpl")
}
# IPs: use wait_for_lease true or after creation use terraform refresh and terraform show for the ips of domain
