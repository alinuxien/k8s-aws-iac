resource "null_resource" "plays_k8s-master" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory ../ansible/install-cfssl-kubectl.yml"
  }

  depends_on = [
    aws_nat_gateway.ngw-a,
    aws_instance.k8s-node-master-a
  ]
}

