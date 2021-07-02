resource "null_resource" "prepare-and-deploy-encryption" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/prepare-encryption.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/push-encryption.yml"
  }

  depends_on = [
    aws_instance.controller-0,
    aws_instance.controller-1,
    aws_instance.worker-0,
    aws_instance.worker-1,
    aws_instance.bastion,
    aws_nat_gateway.ngw-a,
    aws_nat_gateway.ngw-b,
    local_file.AnsibleInventory
  ]
}

resource "null_resource" "cleaning-temp-encryption-files" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/clean-encryption.yml"
  }

  depends_on = [
    null_resource.prepare-and-deploy-encryption
  ]
}

