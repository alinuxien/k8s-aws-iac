# Extract pods subnet cidr from the global pods CIDR
module "subnet_addrs" {
  source          = "hashicorp/subnets/cidr"
  base_cidr_block = var.cluster-pods-cidr
  networks = [
    {
      name     = "worker-0-pods-network"
      new_bits = 8
    },
    {
      name     = "worker-1-pods-network"
      new_bits = 8
    },
  ]
}

resource "aws_route" "worker-0-pods-route-to-other-node-pods" {
  route_table_id         = aws_route_table.private-b-route-to-internet.id
  destination_cidr_block = module.subnet_addrs.networks[0].cidr_block
  instance_id            = aws_instance.worker-0.id
}

resource "aws_route" "worker-1-pods-route-to-other-node-pods" {
  route_table_id         = aws_route_table.private-a-route-to-internet.id
  destination_cidr_block = module.subnet_addrs.networks[1].cidr_block
  instance_id            = aws_instance.worker-1.id
}

