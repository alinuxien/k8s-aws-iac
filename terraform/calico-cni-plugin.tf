resource "null_resource" "calico-cni-plugin" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/calico-cni-plugin.yml -e 'ansible_become=yes ansible_become_user=vagrant ansible_become_pass=vagrant'"
  }

  depends_on = [null_resource.kubectl-remote]
}

