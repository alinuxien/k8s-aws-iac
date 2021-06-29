resource "aws_ami_from_instance" "controller-0-ami" {
  name               = "controller-0-ami"
  source_instance_id = aws_instance.controller-0.id
  depends_on         = [null_resource.dns-cluster-add-on]
}

resource "aws_ami_from_instance" "controller-1-ami" {
  name               = "controller-1-ami"
  source_instance_id = aws_instance.controller-1.id
  depends_on         = [null_resource.dns-cluster-add-on]
}

resource "aws_ami_from_instance" "worker-0-ami" {
  name               = "worker-0-ami"
  source_instance_id = aws_instance.worker-0.id
  depends_on         = [null_resource.dns-cluster-add-on]
}

resource "aws_ami_from_instance" "worker-1-ami" {
  name               = "worker-1-ami"
  source_instance_id = aws_instance.worker-1.id
  depends_on         = [null_resource.dns-cluster-add-on]
}

