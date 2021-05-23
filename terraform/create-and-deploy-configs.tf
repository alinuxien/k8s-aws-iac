resource "null_resource" "prepare-and-deploy-configs" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/prepare-configs.yml"
  }

  depends_on = [
    null_resource.prepare-and-deploy-certs,
    local_file.AnsibleK8SKubeConfigPreparation
  ]
}

resource "null_resource" "cleaning-temp-files" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/clean-certs.yml"
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/clean-configs.yml"
 }

  depends_on = [
    null_resource.prepare-and-deploy-configs
  ]
}

