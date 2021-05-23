resource "null_resource" "prepare-and-deploy-configs" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/prepare-configs.yml"
  }
  
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/push-configs-workers.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/push-configs-controllers.yml"
  }

  depends_on = [
    null_resource.prepare-and-deploy-certs,
    local_file.AnsibleK8SKubeConfigPreparation
  ]
}

resource "null_resource" "cleaning-temp-certs-files" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/clean-certs.yml"
  }

  depends_on = [
    null_resource.prepare-and-deploy-configs
  ]
}

resource "null_resource" "cleaning-temp-config-files" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/clean-configs.yml"
  }

  depends_on = [
    null_resource.prepare-and-deploy-configs
  ]
}

