variable "project_name" {
  type        = string
  description = "Project Name"
  default     = "K8S"
}

variable "ami-bastion" {
  type        = string
  description = "Image Amazon à utiliser pour le Bastion SSH"
  default     = "ami-0de12f76efe134f2f"
}

variable "bastion-user" {
  type        = string
  description = "Nom utilisateur SSH pour le bastion"
  default     = "ec2-user"
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

