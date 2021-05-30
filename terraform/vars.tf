variable "project_name" {
  type        = string
  description = "Project Name"
  default     = "K8S"
}

variable "ami-bastion" {
  type        = string
  description = "Image Amazon à utiliser pour le Bastion SSH"
  default     = "ami-0f7cd40eac2214b37"
}

variable "bastion-user" {
  type        = string
  description = "Nom utilisateur SSH pour le bastion"
  default     = "ubuntu"
}

variable "instance-type-bastion" {
  type        = string
  description = "Type d'Instance à utiliser pour le Bastion SSH"
  default     = "t2.micro"
}

variable "public_key_file" {
  type        = string
  description = "Chemin complet du fichier contenant la cle publique"
}

variable "private_key_file" {
  type        = string
  description = "Chemin complet du fichier contenant la cle privee"
}

variable "ami-k8s-nodes" {
  type        = string
  description = "Image Amazon à utiliser pour les nodes Kubernetes"
  default     = "ami-0f7cd40eac2214b37"
}

variable "k8s-nodes-user" {
  type        = string
  description = "Nom utilisateur SSH pour les nodes Kubernetes"
  default     = "ubuntu"
}

variable "instance-type-k8s-node-controller" {
  type        = string
  description = "Type d'Instance à utiliser pour les nodes Master Kubernetes"
  default     = "t2.micro"
}

variable "instance-type-k8s-node-worker" {
  type        = string
  description = "Type d'Instance à utiliser pour les nodes Worker Kubernetes"
  default     = "t2.micro"
}

variable "api-server-ip" {
  type        = string
  description = "Addresse IP de l'API Server Kubernetes"
  default     = "10.32.0.1"
}

variable "internal-cluster-ip-cidr" {
  type        = string
  description = "Plage d'adresses IP réservée pour les services internes du Cluster Kubernetes"
  default     = "10.32.0.0/24"
}

variable "pod-cidr" {
  type        = string
  description = "Plage d'allocation des sous-réseaux réservée pour les PODS"
  default     = "10.200.0.0/16"
}

