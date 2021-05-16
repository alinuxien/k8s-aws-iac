output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "k8s-node-master-a_ip" {
  value = aws_instance.k8s-node-master-a.private_ip
}

resource "local_file" "AnsibleInventory" {
  content = templatefile("../ansible/inventory.tmpl", {
    bastion-dns           = aws_instance.bastion.private_dns,
    bastion-ip            = aws_instance.bastion.public_ip,
    bastion-id            = aws_instance.bastion.id,
    bastion-user          = var.bastion-user,
    k8s-node-master-a-dns = aws_instance.k8s-node-master-a.private_dns,
    k8s-node-master-a-ip  = aws_instance.k8s-node-master-a.private_ip,
    k8s-node-master-a-id  = aws_instance.k8s-node-master-a.id,
    k8s-nodes-user        = var.k8s-nodes-user,
    private_key_file      = var.private_key_file
  })
  filename = "../ansible/inventory"
}

resource "local_file" "AnsibleK8SCertificatePreparation" {
  content = templatefile("../ansible/roles/prepare-certs/tasks/main.tmpl", {
    master-a-ext-ip = aws_instance.k8s-node-master-a.public_ip,
    master-a-int-ip = aws_instance.k8s-node-master-a.private_ip
  })
  filename = "../ansible/roles/prepare-certs/tasks/mains.yml"
}


