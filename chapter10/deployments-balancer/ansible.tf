resource "null_resource" "cluster" {

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory playbooks/provision.yml"
  }

  depends_on = [
   libvirt_domain.bal1,
   libvirt_domain.app1,
   libvirt_domain.app2
  ]
}
