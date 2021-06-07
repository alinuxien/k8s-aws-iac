resource "null_resource" "kubectl-remote" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/kubectl-remote.yml"
  }

  depends_on = [
    null_resource.control-plane,
    null_resource.workers-bootstraping,
    local_file.AnsibleK8SKubectl-Remote
  ]
}

resource "null_resource" "cleaning-temp-certs-files" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/clean-certs.yml"
  }

  depends_on = [
    null_resource.kubectl-remote
  ]
}

resource "null_resource" "cleaning-temp-config-files" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/clean-configs.yml"
  }

  depends_on = [
    null_resource.kubectl-remote
  ]
}

