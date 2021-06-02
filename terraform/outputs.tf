output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "controller-0_ip" {
  value = aws_instance.controller-0.private_ip
}

output "controller-1_ip" {
  value = aws_instance.controller-1.private_ip
}
output "worker-0_ip" {
  value = aws_instance.worker-0.private_ip
}
output "worker-1_ip" {
  value = aws_instance.worker-1.private_ip
}

output "kubernetes-public-adress" {
  value = aws_lb.lb.dns_name
}

resource "local_file" "AnsibleInventory" {
  content = templatefile("../ansible/inventory.tmpl", {
    bastion-dns      = aws_instance.bastion.private_dns,
    bastion-ip       = aws_instance.bastion.public_ip,
    bastion-id       = aws_instance.bastion.id,
    bastion-user     = var.bastion-user,
    controller-0-dns = aws_instance.controller-0.private_dns,
    controller-0-ip  = aws_instance.controller-0.private_ip,
    controller-0-id  = aws_instance.controller-0.id,
    controller-1-dns = aws_instance.controller-1.private_dns,
    controller-1-ip  = aws_instance.controller-1.private_ip,
    controller-1-id  = aws_instance.controller-1.id,
    worker-0-dns     = aws_instance.worker-0.private_dns,
    worker-0-ip      = aws_instance.worker-0.private_ip,
    worker-0-id      = aws_instance.worker-0.id,
    worker-1-dns     = aws_instance.worker-1.private_dns,
    worker-1-ip      = aws_instance.worker-1.private_ip,
    worker-1-id      = aws_instance.worker-1.id,
    k8s-nodes-user   = var.k8s-nodes-user,
    private_key_file = var.private_key_file
  })
  filename = "../ansible/inventory.ini"
}

resource "local_file" "AnsibleK8SCertificatePreparation" {
  content = templatefile("../ansible/roles/prepare-certs/tasks/main.tmpl", {
    controller-0-ext-ip      = aws_instance.controller-0.public_ip,
    controller-0-int-ip      = aws_instance.controller-0.private_ip,
    controller-1-ext-ip      = aws_instance.controller-1.public_ip,
    controller-1-int-ip      = aws_instance.controller-1.private_ip,
    worker-0-ext-ip          = aws_instance.worker-0.public_ip,
    worker-0-int-ip          = aws_instance.worker-0.private_ip,
    worker-1-ext-ip          = aws_instance.worker-1.public_ip,
    worker-1-int-ip          = aws_instance.worker-1.private_ip,
    kubernetes-public-adress = aws_lb.lb.dns_name,
    kubernetes-hostnames     = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local",
    api-server-ip            = var.api-server-ip
  })
  filename = "../ansible/roles/prepare-certs/tasks/main.yml"
}

resource "local_file" "AnsibleK8SKubeConfigPreparation" {
  content = templatefile("../ansible/roles/prepare-configs/tasks/main.tmpl", {
    controller-0-ext-ip      = aws_instance.controller-0.public_ip,
    controller-0-int-ip      = aws_instance.controller-0.private_ip,
    controller-1-ext-ip      = aws_instance.controller-1.public_ip,
    controller-1-int-ip      = aws_instance.controller-1.private_ip,
    worker-0-ext-ip          = aws_instance.worker-0.public_ip,
    worker-0-int-ip          = aws_instance.worker-0.private_ip,
    worker-1-ext-ip          = aws_instance.worker-1.public_ip,
    worker-1-int-ip          = aws_instance.worker-1.private_ip,
    kubernetes-public-adress = aws_lb.lb.dns_name,
    kubernetes-hostnames     = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local",
    api-server-ip            = var.api-server-ip
  })
  filename = "../ansible/roles/prepare-configs/tasks/main.yml"
}

resource "local_file" "AnsibleK8SETCD" {
  content = templatefile("../ansible/roles/etcd-config/tasks/main.tmpl", {
    controller-0-int-ip = aws_instance.controller-0.private_ip,
    controller-1-int-ip = aws_instance.controller-1.private_ip,
    worker-0-int-ip     = aws_instance.worker-0.private_ip,
    worker-1-int-ip     = aws_instance.worker-1.private_ip,
    controller-0-id     = regex("^ip[-0-9]*", aws_instance.controller-0.private_dns)
    controller-1-id     = regex("^ip[-0-9]*", aws_instance.controller-1.private_dns)
  })
  filename = "../ansible/roles/etcd-config/tasks/main.yml"
}

resource "local_file" "AnsibleK8SControlPlane" {
  content = templatefile("../ansible/roles/control-plane/tasks/main.tmpl", {
    kubernetes-public-adress = aws_lb.lb.dns_name,
    controller-0-int-ip      = aws_instance.controller-0.private_ip,
    controller-1-int-ip      = aws_instance.controller-1.private_ip,
    worker-0-int-ip          = aws_instance.worker-0.private_ip,
    worker-1-int-ip          = aws_instance.worker-1.private_ip
    service-cluster-ip-range = var.internal-cluster-ip-cidr,
    pod-cidr                 = var.pod-cidr
  })
  filename = "../ansible/roles/control-plane/tasks/main.yml"
}

resource "local_file" "AnsibleK8SWorkers" {
  content = templatefile("../ansible/roles/workers/tasks/main.tmpl", {
    pod-cidr = var.pod-cidr
  })
  filename = "../ansible/roles/workers/tasks/main.yml"
}


