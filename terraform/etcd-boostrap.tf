resource "null_resource" "etcd-bootstrap" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/etcd-bootstrap.yml"
  }

  depends_on = [
    null_resource.prepare-and-deploy-encryption
  ]
}

