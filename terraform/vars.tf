variable "project_name" {
  type        = string
  description = "Project Name"
  default     = "K8S"
}

variable "bastion-ami" {
  type        = string
  description = "Bastion Host AMI"
  default     = "ami-0f7cd40eac2214b37"
}

variable "bastion-user" {
  type        = string
  description = "Bastion Host Username ( depends on Bastion Host AMI )"
  default     = "ubuntu"
}

variable "bastion-instance-type" {
  type        = string
  description = "Bastion Host Instance Type"
  default     = "t2.micro"
}

variable "public_key_file" {
  type        = string
  description = "Personnal Public Key Full Path"
}

variable "private_key_file" {
  type        = string
  description = "Personnal Private Key Full Path"
}

variable "k8s-nodes-ami" {
  type        = string
  description = "Kubernetes Cluster Nodes AMI"
  default     = "ami-0f7cd40eac2214b37"
}

variable "k8s-nodes-user" {
  type        = string
  description = "Kubernetes Cluster Nodes Username ( depends on Kubernets Cluster Node AMI )"
  default     = "ubuntu"
}

variable "k8s-controller-nodes-instance-type" {
  type        = string
  description = "Kubernetes Cluster Controller Nodes Instance Type"
  default     = "t2.micro"
}

variable "k8s-worker-nodes-instance-type" {
  type        = string
  description = "Kubernetes Cluster Worker Nodes Instance Type"
  default     = "t2.micro"
}

variable "api-server-ip" {
  type        = string
  description = "Kubernetes Cluster Componenet API Server IP"
  default     = "10.32.0.1"
}

variable "cluster-services-cidr" {
  type        = string
  description = "Kubernetes Cluster Services CIDR Block"
  default     = "10.32.0.0/24"
}

variable "cluster-pods-cidr" {
  type        = string
  description = "Kubernetes Cluster Pods CIDR Block"
  default     = "10.200.0.0/16"
}

variable "app-domain" {
  type        = string
  description = "Kubernetes Cluster Applications Domain Name ( must be a real domain )"
  default     = "yourdomain.ext"
}
