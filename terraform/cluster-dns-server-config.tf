resource "null_resource" "dns-server-config" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/dns-server-config.yml -e 'ansible_become=yes ansible_become_user=vagrant ansible_become_pass=vagrant'"
  }

  depends_on = [
    null_resource.remote-kubectl-config,
    aws_route.worker-1-pods-route-to-other-node-pods,
    aws_route.worker-0-pods-route-to-other-node-pods,
    null_resource.pods-network-overlay
  ]
}


