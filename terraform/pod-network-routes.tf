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

resource "aws_route_table" "worker-0-pod-rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block  = module.subnet_addrs.network_cidr_blocks[0].value
    instance_id = aws_instance.worker-0.id
  }
  tags = {
    Name = "worker-0-pod-route-table"
  }
}

resource "aws_route_table" "worker-1-pod-rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block  = module.subnet_addrs.network_cidr_blocks[1].value
    instance_id = aws_instance.worker-1.id
  }
  tags = {
    Name = "worker-1-pod-route-table"
  }
}


