resource "null_resource" "prepare-and-deploy-certificates" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/prepare-certificates.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/push-certificates-to-workers.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/push-certificates-to-controllers.yml"
  }

  depends_on = [
    aws_nat_gateway.nat-gateway-public-a,
    aws_nat_gateway.nat-gateway-public-b,
    aws_instance.bastion,
    aws_instance.controller-0,
    aws_instance.controller-1,
    aws_instance.worker-0,
    aws_instance.worker-1,
    aws_lb.nlb,
    local_file.inventory-file,
    local_file.certificates-preparation-file,
    local_file.certificates-push-file
  ]
}
