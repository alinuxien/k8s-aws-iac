resource "time_sleep" "wait_60_seconds" {
  depends_on = [null_resource.flannel-cni-plugin]

  create_duration = "60s"
}

resource "null_resource" "dns-cluster-add-on" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/dns-cluster-add-on.yml -e 'ansible_become=yes ansible_become_user=vagrant ansible_become_pass=vagrant'"
  }

  depends_on = [time_sleep.wait_60_seconds]
}


