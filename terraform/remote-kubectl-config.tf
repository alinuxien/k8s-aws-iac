resource "null_resource" "remote-kubectl-config" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/remote-kubectl-config.yml -e 'ansible_become=yes ansible_become_user=vagrant ansible_become_pass=vagrant'"
  }

  depends_on = [
    null_resource.control-plane-bootstrap,
    null_resource.workers-bootstrap,
    local_file.remote-kubectl-file
  ]
}


