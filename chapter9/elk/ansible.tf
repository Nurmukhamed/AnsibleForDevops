resource "null_resource" "cluster" {

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory provisioning/elk/main.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory provisioning/web/main.yml"
  }

  depends_on = [
   libvirt_domain.logs,
   libvirt_domain.web
  ]
}
