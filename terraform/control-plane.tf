resource "null_resource" "control-plane" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/control-plane.yml"
  }

  depends_on = [
    null_resource.etcd-bootstrap,
    localfile.AnsibleK8SControlPlane
  ]
}

