resource "null_resource" "prepare-and-deploy-certs" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/prepare-certs.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/push-certs-workers.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/push-certs-controllers.yml"
  }

  depends_on = [
    aws_nat_gateway.ngw-a,
    aws_instance.bastion,
    aws_instance.k8s-node-master-a,
    aws_lb.lb,
    local_file.AnsibleK8SCertificatePreparation
  ]
}
