variable "ami-webserver" {
  type        = string
  description = "Image Amazon à utiliser pour le serveur Web"
  default     = "ami-0de12f76efe134f2f"
}

variable "webservers-user" {
  type        = string
  description = "Nom utilisateur SSH pour les serveurs web"
  default     = "ec2-user"
}

variable "instance-type-webserver" {
  type        = string
  description = "Type d'Instance à utiliser pour le serveur Web"
  default     = "t2.micro"
}

variable "instance-type-elasticsearch" {
  type        = string
  description = "Type d'Instance à utiliser pour le Cluster ElasticSearch"
  default     = "t3.medium.elasticsearch"
}

variable "instance-type-logstash" {
  type        = string
  description = "Type d'Instance à utiliser pour le serveur LogStash"
  default     = "t3.small"
}


variable "webserver-homepage-path" {
  type        = string
  description = "Chemin complet et absolu des pages Web sur le serveur Web"
  default     = "/srv/www/htdocs"
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

variable "private_key_file" {
  type        = string
  description = "Chemin complet du fichier contenant la cle privee"
}

variable "public_key_file" {
  type        = string
  description = "Chemin complet du fichier contenant la cle publique"
}

variable "database-name" {
  type        = string
  description = "Nom de la base de données à créer"
  default     = "terraform"
}

variable "database-username" {
  type        = string
  description = "Nom utilisateur pour connexion à la BD"
  default     = "terraform"
}

variable "database-password" {
  type        = string
  description = "Password utlisateur pour connexion à la BD"
  default     = "alinuxien"
}

variable "domain" {
  type        = string
  description = "Nom de domaine du site Web"
}

variable "es-domain" {
  type        = string
  description = "Nom de domaine du site Web"
  default     = "elastic"
}

variable "website_title" {
  type        = string
  description = "Titre du site Web"
  default     = "YourWebSite"
}

variable "website_admin" {
  type        = string
  description = "Nom utilisateur admin du site Web"
}

variable "website_admin_pass" {
  type        = string
  description = "Mot de passe admin du site Web"
}

variable "website_admin_email" {
  type        = string
  description = "Adresse email admin du site Web"
}

