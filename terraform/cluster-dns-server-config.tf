resource "null_resource" "dns-server-config" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/dns-server-config.yml -e 'ansible_become=yes ansible_become_user=vagrant ansible_become_pass=vagrant'"
  }

  depends_on = [
    null_resource.kubectl-remote,
    aws_route.worker-1-pod-route-a,
    aws_route.worker-0-pod-route-b,
    null_resource.pods-network-overlay
  ]
}


