# Bienvenue sur mon projet de création d'un Cluster Kubernetes sur AWS par l'Infrastructure As Code
Il s'agit d'un projet réalisé en Mai et Juin 2021 dans le cadre de ma formation "Expert DevOps" chez OpenClassRooms.

## AVERTISSEMENT
Il s'agit seulement d'un projet d'étude, à NE PAS UTILISER EN PROD  !!!
Des outils bien plus simple, efficace et sécurisés sont disponibles en ligne, comme par exemple [Kops](https://kubernetes.io/fr/docs/setup/custom-cloud/kops/)

## Ca fait quoi ?
Ca crée un Cluster Kubernetes sur AWS, composé de 2 nodes Controller et 2 nodes Worker, avec un Serveur DNS interne au Cluster, et le réseau configuré pour permettre la communication entre les Pods.

Une fois disponible, on peut y déployer des pods, des deployment et des services Kubernetes à partir de la VM locale qui a permis la construction.

Afin d'automatiser l'infrastructure, j'ai utilisé Terraform et Ansible, et j'ai utilisé la CI/CD de GitLab pour développer.

Le Cluster est créé "from scratch", sans recours à des helper comme kubeadm, et est inspiré du tutoriel de Kelsey Hightower, "M. Cloud" chez Google, disponible ici : [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way).

Encore une fois, ce n'est pas du tout un contexte idéal pour créer efficacement des Clusters Kubernetes, mais le but était d'expérimenter toutes les étapes et les composants qui constituent un Cluster.

Mais je vous rassure : tout est automatisé avec GitLab, Terraform et Ansible !!!

## Ca ressemble à quoi ?
![Vue d'ensemble de l'Architecture Cloud AWS](https://github.com/alinuxien/k8s-aws-iac/blob/master/K8s%20on%20AWS%20-%20Global%20Architecture.png)


![Vue d'ensemble de l'Architecture Réseaux entre Pods et entre Nodes Kubernetes](https://github.com/alinuxien/k8s-aws-iac/blob/master/K8s%20on%20AWS%20-%20PODS%20Networking.png)
## Contenu ?
- Un pipeline de CI/CD Gitlab : `gitlab-ci.yml` 
- Le dossier `certs` contient tous les fichiers json nécessaires à la création des Certificats pour le Cluster
- Le dossier `terraform` contient les scripts de création des ressources sur AWS
- Le dossier `ansible` contient les playbooks de configuration des ressources sur AWS
- Le fichier `coredns-1.8.yaml` est un manifeste Kubernetes complet pour la configuration du Serveur DNS interne au Cluster
 
## J'ai besoin de quoi ?
- Une VM GitLab locale, avec certains utilitaires, et un Runner de type Shell. Vous pouvez trouver de quoi en créer une sur mesure sur mon projet [gitlab-iac](https://github.com/alinuxien/gitlab-iac)
- Un compte AWS avec un bucket S3 pour stocker les Remote State Terraform. Vous trouverez les instructions si besoin [ici](https://docs.aws.amazon.com/fr_fr/AmazonS3/latest/user-guide/create-bucket.html)
- Un nom de domaine valide pour pouvoir accéder aux pods applicatifs depuis un navigateur web. Ce nom de domaine doit être soit hébergé chez AWS Route 53, soit configuré pour déléguer la gestion à AWS Route 53

## Comment ça s'utilise ?
Chez AWS, pour ceux qui hébergent leur nom de domaine hors AWS Route 53 :

créez une zone hébergée sur votre nom de domaine ( ou sous-domaine ), service Route 53, 
notez les noms des 4 serveurs DNS apparus dans l'enregistrement de type NS, et réalisez la redirection chez votre provider DNS ( 4 enregistrements de type NS aussi, je ne m'étale pas sur ce point )

Chez AWS, pour tous : 
créez un certificat AWS ACM sur votre nom de domaine, service Certificate Manager, avec validation par DNS, avec l'assitance automatique Route 53 ( puisque c'est maintenant lui qui gère le domaine / sous-domaine )

Dans un Terminal : 
- générez une paire de clés SSH qui seront dédiées au Cluster, dans le dossier de votre choix : `ssh-keygen -f chemin-au-choix/nom-de-la-clé-au-choix`

Ensuite,dans GitLab :
- vous devez créer un nouveau projet et y déposer le contenu de ce dépot ( `https://github.com/alinuxien/k8s-aws-iac` )
- éditez le fichier `terraform.tfvars` pour le personnaliser, notamment l'emplacement de la paire de clés ( privée et publique, **en chemin complet** ), le nom de domaine dans la variable `app-domain`, et les types d'instance pour les nodes du Cluster, `k8s-controller-nodes-instance-type` et `k8s-worker-nodes-instance-type` ( j'ai choisi `c5d.xlarge` pour accélérer un peu le process mais `t2.micro` fonctionne très bien, et est beaucoup moins cher :) )
Pour information, Terraform utilise 2 fichiers pour gérer les variables : `vars.tf` pour déclarer les variables et éventuellement leur donner une valeur par défaut, et `terraform.tfvars` pour spécifier la valeur des variables si elles n'ont pas valeur par défaut ou changer la valeur par défaut.
- vous allez créer des variables de CI/CD pour renseigner les crédentials AWS : 
- Dans le projet, allez dans le menu de gauche, Settings -> CI/CD, puis développez les `Variables`, et créez : 
- AWS_ACCESS_KEY_ID **en masqué**
- AWS_SECRET_ACCESS_KEY **en masqué**
- AWS_DEFAULT_REGION ( eu-west-3 par exemple )
- AWS_REGION ( eu-west-3 par exemple )
- AWS_STATE_BUCKET : le nom du bucket S3
- AWS_STATE_KEY : un nom au choix, comme le nom du projet, qui sera utilisé comme racine pour le nom des objets de Remote State Terraform
- TF_IN_AUTOMATION : true

Et voilà! L'environnement de travail est prêt. Il suffit d'exécuter le pipeline : 
-> dans GitLab, menu de gauche, CI/CD -> Pipelines
-> cliquez sur le bouton bleu en haut à doite `Run Pipeline`
-> le reste est automatique : GitLab va faire des vérification, planifier, et créer le Cluster. 
-> la dernière étape ( sur 4 ), sert à détruire le Cluster sur AWS, et est manuelle, pour que vous puissiez en profiter un peu d'abord... D'ailleurs, pensez bien à détruire le Cluster, dans tous les cas, pour ne pas allourdir votre facture AWS inutilement.

Quand le Cluster est créé, pour tester, dans un terminal :
- `kubectl version` 
- `kubectl cluster-info`
- `kubectl get nodes` liste les noeuds enregistrés dans le cluster
- `kubectl get all -A` liste tous les objets Kubernetes existant dans le cluster, sur tous les namespaces

# Et après ?
Pour tjouer avec ce Cluster, je vous propose la suite du projet, qui consiste à mettre en place un Service On Demand, capable de déployer des applications PHP-MySQL depuis GitLab vers le Cluster, et  
[disponible ici](https://github.com/alinuxien/service-on-demand)

