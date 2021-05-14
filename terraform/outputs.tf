output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "k8s-node-master-a_ip" {
  value = aws_instance.node-master-a.private_ip
}



