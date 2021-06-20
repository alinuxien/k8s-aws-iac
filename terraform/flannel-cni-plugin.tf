resource "time_sleep" "wait_30_seconds" {
  depends_on = [
    null_resource.kubectl-remote,
    aws_route.worker-1-pod-route-a,
    aws_route.worker-0-pod-route-b
  ]

  create_duration = "30s"
}

resource "null_resource" "flannel-cni-plugin" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/flannel-cni-plugin.yml -e 'ansible_become=yes ansible_become_user=vagrant ansible_become_pass=vagrant'"
  }

  depends_on = [time_sleep.wait_30_seconds]
}


