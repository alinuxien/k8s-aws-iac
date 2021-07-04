# Here you can override variables default value defined in vars.tf
project_name                       = "k8s-2c-2w-in-2azs"
public_key_file                    = "/home/vagrant/on-demand-infra/credentials/id_rsa_aws_k8s.pub"
private_key_file                   = "/home/vagrant/on-demand-infra/credentials/id_rsa_aws_k8s"
app-domain                         = "kube.akrour.fr"
k8s-controller-nodes-instance-type = "t3.small"
