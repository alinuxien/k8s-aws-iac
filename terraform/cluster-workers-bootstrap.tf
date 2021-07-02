resource "null_resource" "workers-bootstrap" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/workers-bootstrap.yml"
  }

  depends_on = [
    null_resource.prepare-and-deploy-certificates,
    null_resource.prepare-and-deploy-kubeconfigs,
    local_file.workers-bootstrap-file
  ]
}

