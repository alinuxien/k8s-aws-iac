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


