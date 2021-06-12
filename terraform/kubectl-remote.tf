resource "null_resource" "kubectl-remote" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/kubectl-remote.yml -e 'ansible_user=vagrant'"
  }

  depends_on = [
    null_resource.control-plane,
    null_resource.workers-bootstraping,
    local_file.AnsibleK8SKubectl-Remote
  ]
}


