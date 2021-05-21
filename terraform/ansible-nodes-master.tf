resource "null_resource" "plays_k8s-master" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/prepare-certs.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/push-certs.yml"
  }

 depends_on = [
    aws_nat_gateway.ngw-a,
    aws_instance.bastion,
    aws_instance.k8s-node-master-a,
    local_file.AnsibleK8SCertificatePreparation
  ]
}

