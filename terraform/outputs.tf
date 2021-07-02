output "bastion-ip" {
  value = aws_instance.bastion.public_ip
}

output "controller-0-ip" {
  value = aws_instance.controller-0.private_ip
}

output "controller-1-ip" {
  value = aws_instance.controller-1.private_ip
}
output "worker-0-ip" {
  value = aws_instance.worker-0.private_ip
}
output "worker-1-ip" {
  value = aws_instance.worker-1.private_ip
}

output "kubernetes-public-adress" {
  value = aws_lb.nlb.dns_name
}

output "alb-dns-name" {
  value = aws_lb.alb.dns_name
}

resource "local_file" "inventory-file" {
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

resource "local_file" "certificates-preparation-file" {
  content = templatefile("../ansible/roles/prepare-certificates/tasks/main.tmpl", {
    controller-0-ext-ip      = aws_instance.controller-0.public_ip,
    controller-0-int-ip      = aws_instance.controller-0.private_ip,
    controller-1-ext-ip      = aws_instance.controller-1.public_ip,
    controller-1-int-ip      = aws_instance.controller-1.private_ip,
    worker-0-ext-ip          = aws_instance.worker-0.public_ip,
    worker-0-int-ip          = aws_instance.worker-0.private_ip,
    worker-1-ext-ip          = aws_instance.worker-1.public_ip,
    worker-1-int-ip          = aws_instance.worker-1.private_ip,
    kubernetes-public-adress = aws_lb.nlb.dns_name,
    kubernetes-hostnames     = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local",
    api-server-ip            = var.api-server-ip
  })
  filename = "../ansible/roles/prepare-certificates/tasks/main.yml"
}

resource "local_file" "certificates-push-file" {
  content = templatefile("../ansible/roles/push-certificates-to-workers/tasks/main.tmpl", {
    worker-0-dns = aws_instance.worker-0.private_dns,
    worker-1-dns = aws_instance.worker-1.private_dns
  })
  filename = "../ansible/roles/push-certificates-to-workers/tasks/main.yml"
}

resource "local_file" "kubeconfigs-preparation-file" {
  content = templatefile("../ansible/roles/prepare-kubeconfigs/tasks/main.tmpl", {
    controller-0-ext-ip      = aws_instance.controller-0.public_ip,
    controller-0-int-ip      = aws_instance.controller-0.private_ip,
    controller-1-ext-ip      = aws_instance.controller-1.public_ip,
    controller-1-int-ip      = aws_instance.controller-1.private_ip,
    worker-0-ext-ip          = aws_instance.worker-0.public_ip,
    worker-0-int-ip          = aws_instance.worker-0.private_ip,
    worker-1-ext-ip          = aws_instance.worker-1.public_ip,
    worker-1-int-ip          = aws_instance.worker-1.private_ip,
    kubernetes-public-adress = aws_lb.nlb.dns_name,
    kubernetes-hostnames     = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local",
    api-server-ip            = var.api-server-ip
  })
  filename = "../ansible/roles/prepare-kubeconfigs/tasks/main.yml"
}

resource "local_file" "kubeconfigs-push-file" {
  content = templatefile("../ansible/roles/push-kubeconfigs-to-workers/tasks/main.tmpl", {
    worker-0-dns = aws_instance.worker-0.private_dns,
    worker-1-dns = aws_instance.worker-1.private_dns
  })
  filename = "../ansible/roles/push-kubeconfigs-to-workers/tasks/main.yml"
}

resource "local_file" "etcd-bootstrap-file" {
  content = templatefile("../ansible/roles/etcd-config/tasks/main.tmpl", {
    controller-0-int-ip = aws_instance.controller-0.private_ip,
    controller-1-int-ip = aws_instance.controller-1.private_ip,
    worker-0-int-ip     = aws_instance.worker-0.private_ip,
    worker-1-int-ip     = aws_instance.worker-1.private_ip,
    controller-0-id     = regex("^ip[-0-9]*", aws_instance.controller-0.private_dns),
    controller-1-id     = regex("^ip[-0-9]*", aws_instance.controller-1.private_dns)
  })
  filename = "../ansible/roles/etcd-config/tasks/main.yml"
}

resource "local_file" "control-plane-bootstrap-file" {
  content = templatefile("../ansible/roles/control-plane-bootstrap/tasks/main.tmpl", {
    kubernetes-public-adress = aws_lb.nlb.dns_name,
    controller-0-int-ip      = aws_instance.controller-0.private_ip,
    controller-1-int-ip      = aws_instance.controller-1.private_ip,
    worker-0-int-ip          = aws_instance.worker-0.private_ip,
    worker-1-int-ip          = aws_instance.worker-1.private_ip,
    service-cluster-ip-range = var.cluster-services-cidr,
    cluster-pods-cidr        = var.cluster-pods-cidr
  })
  filename = "../ansible/roles/control-plane-bootstrap/tasks/main.yml"
}

resource "local_file" "workers-bootstrap-file" {
  content = templatefile("../ansible/roles/workers-bootstrap/tasks/main.tmpl", {
    cluster-pods-cidr   = var.cluster-pods-cidr,
    controller-0-int-ip = aws_instance.controller-0.private_ip,
    controller-1-int-ip = aws_instance.controller-1.private_ip,
    worker-0-int-ip     = aws_instance.worker-0.private_ip,
    worker-1-int-ip     = aws_instance.worker-1.private_ip,
    worker-0-dns        = aws_instance.worker-0.private_dns,
    worker-1-dns        = aws_instance.worker-1.private_dns,
    cluster-pods-cidr-0 = module.subnet_addrs.networks[0].cidr_block,
    cluster-pods-cidr-1 = module.subnet_addrs.networks[1].cidr_block
  })
  filename = "../ansible/roles/workers/tasks/main.yml"
}

resource "local_file" "remote-kubectl-file" {
  content = templatefile("../ansible/roles/kubectl-remote/tasks/main.tmpl", {
    kubernetes-public-adress = aws_lb.nlb.dns_name
  })
  filename = "../ansible/roles/kubectl-remote/tasks/main.yml"
}

