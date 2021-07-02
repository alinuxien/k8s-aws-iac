resource "null_resource" "kubectl-remote" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/kubectl-remote.yml -e 'ansible_become=yes ansible_become_user=vagrant ansible_become_pass=vagrant'"
  }

  depends_on = [
    null_resource.control-plane-boostrap,
    null_resource.workers-bootstraping,
    local_file.AnsibleK8SKubectl-Remote
  ]
}


