resource "null_resource" "prepare-and-deploy-encryption" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/encryption.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/push-encryption.yml"
  }

  depends_on = [
    aws_instance.bastion,
    aws_instance.k8s-node-master-a,
  ]
}
