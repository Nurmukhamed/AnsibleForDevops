resource "null_resource" "cluster" {

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory deployments/playbooks/main.yml"
  }

  depends_on = [
   libvirt_domain.rails,
  ]
}
