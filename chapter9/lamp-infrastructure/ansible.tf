resource "null_resource" "cluster" {

  provisioner "local-exec" {
    command = "ansible-playbook configure.yml"
  }

  depends_on = [
   libvirt_domain.varnish,
   libvirt_domain.www1,
   libvirt_domain.www2,
   libvirt_domain.db1,
   libvirt_domain.db2,
   libvirt_domain.memcached
  ]
}
