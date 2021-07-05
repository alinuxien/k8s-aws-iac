resource "null_resource" "prepare-and-deploy-kubeconfigs" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/prepare-kubeconfigs.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/push-kubeconfigs-to-workers.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/push-kubeconfigs-to-controllers.yml"
  }

  depends_on = [
    null_resource.prepare-and-deploy-certificates,
    local_file.kubeconfigs-preparation-file,
    local_file.kubeconfigs-push-file
  ]
}

