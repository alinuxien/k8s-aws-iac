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
    aws_nat_gateway.ngw-a,
    aws_instance.bastion,
    aws_instance.controller-0,
    aws_instance.controller-1,
    aws_instance.worker-0,
    aws_instance.worker-1,
    aws_lb.lb,
    local_file.AnsibleInventory,
    local_file.AnsibleK8SCertificatePreparation,
    local_file.AnsibleK8SCertificatePush
  ]
}
