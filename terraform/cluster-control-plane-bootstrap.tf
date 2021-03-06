resource "null_resource" "control-plane-bootstrap" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/control-plane-bootstrap.yml"
  }

  depends_on = [
    null_resource.prepare-and-deploy-certificates,
    null_resource.prepare-and-deploy-kubeconfigs,
    local_file.control-plane-bootstrap-file
  ]
}

