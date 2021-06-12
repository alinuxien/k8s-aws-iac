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

resource "aws_route" "worker-0-pod-rt" {
  route_table_id         = aws_route_table.private-a.id
  destination_cidr_block = module.subnet_addrs.network_cidr_blocks[0].value
  instance_id            = aws_instance.worker-0.id
  tags = {
    Name = "worker-0-pod-route-table"
  }
}

resource "aws_route" "worker-1-pod-rt" {
  route_table_id         = aws_route_table.private-b.id
  destination_cidr_block = module.subnet_addrs.network_cidr_blocks[1].value
  instance_id            = aws_instance.worker-1.id
  tags = {
    Name = "worker-1-pod-route-table"
  }
}

