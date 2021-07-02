resource "null_resource" "pods-network-overlay" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/pods-network-overlay.yml -e 'ansible_become=yes ansible_become_user=vagrant ansible_become_pass=vagrant'"
  }

  depends_on = [null_resource.remote-kubectl-config]
}
