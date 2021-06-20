module "subnet_addrs" {
  source          = "hashicorp/subnets/cidr"
  base_cidr_block = var.pod-cidr
  networks = [
    {
      name     = "worker-0-pod-network"
      new_bits = 8
    },
    {
      name     = "worker-1-pod-network"
      new_bits = 8
    },
  ]
}

var "pod-cidr-0" {
  type  = string
  value = module.subnet_addrs.networks[0].cidr_block
}

var "pod-cidr-1" {
  type  = string
  value = module.subnet_addrs.networks[1].cidr_block
}

