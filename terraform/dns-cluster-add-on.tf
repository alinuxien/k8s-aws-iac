resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.flannel-cni-plugin]

  create_duration = "30s"
}

resource "null_resource" "dns-cluster-add-on" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/dns-cluster-add-on.yml -e 'ansible_become=yes ansible_become_user=vagrant ansible_become_pass=vagrant'"
  }

  depends_on = [time_sleep.wait_30_seconds]
}


