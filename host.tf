resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile

  associate_public_ip_address = var.associate_public_ip_address
  monitoring                  = var.monitoring

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    throughput  = 200
    volume_size = var.root_block_volume_size
  }

  tags = local.tags
}

resource "aws_ebs_volume" "sdd" {
  count             = var.create_ebs_block_device_sdd ? 1 : 0
  availability_zone = aws_instance.this.availability_zone
  size              = var.ebs_block_device_sdd_size
  type              = "gp3"
  encrypted         = true

  tags = {
    Name = "${var.name}-sdd"
  }
}

resource "aws_volume_attachment" "sdd" {
  count       = var.create_ebs_block_device_sdd ? 1 : 0
  device_name = "/dev/sdd"
  volume_id   = aws_ebs_volume.sdd[0].id
  instance_id = aws_instance.this.id
}

resource "aws_ebs_volume" "sde" {
  count             = var.create_ebs_block_device_sde ? 1 : 0
  availability_zone = aws_instance.this.availability_zone
  size              = var.ebs_block_device_sde_size
  type              = "gp3"
  encrypted         = true

  tags = {
    Name = "${var.name}-sde"
  }
}

resource "aws_volume_attachment" "sde" {
  count       = var.create_ebs_block_device_sde ? 1 : 0
  device_name = "/dev/sde"
  volume_id   = aws_ebs_volume.sde[0].id
  instance_id = aws_instance.this.id
}

resource "aws_ebs_volume" "sdf" {
  count             = var.create_ebs_block_device_sdf ? 1 : 0
  availability_zone = aws_instance.this.availability_zone
  size              = var.ebs_block_device_sdf_size
  type              = "gp3"
  encrypted         = true

  tags = {
    Name = "${var.name}-sdf"
  }
}

resource "aws_volume_attachment" "sdf" {
  count       = var.create_ebs_block_device_sdf ? 1 : 0
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.sdf[0].id
  instance_id = aws_instance.this.id
}
