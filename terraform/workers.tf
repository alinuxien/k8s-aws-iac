resource "time_sleep" "wait_60_seconds" {
  depends_on = [
    null_resource.prepare-and-deploy-certs,
    null_resource.prepare-and-deploy-configs,
    null_resource.control-plane,
    local_file.AnsibleK8SWorkers
  ]
  create_duration = "60s"
}

resource "null_resource" "workers-bootstraping" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/workers.yml"
  }

  depends_on = [time_sleep.wait_60_seconds]
}

