resource "null_resource" "cluster" {

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory playbooks/main.yml"
  }

  depends_on = [
   libvirt_domain.nodejs1,
   libvirt_domain.nodejs2,
   libvirt_domain.nodejs3,
   libvirt_domain.nodejs4
  ]
}
