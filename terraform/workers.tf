resource "null_resource" "workers-bootstraping" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/workers.yml"
  }

  depends_on = [
    null_resource.prepare-and-deploy-certs,
    null_resource.prepare-and-deploy-configs,
    local_file.AnsibleK8SWorkers
  ]
}
