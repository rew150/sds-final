resource "aws_instance" "app" {
  ami                  = var.ami
  availability_zone    = var.availability_zone
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.app.name
  user_data_base64     = data.cloudinit_config.app.rendered

  network_interface {
    network_interface_id = aws_network_interface.app2gw.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.app2db.id
    device_index         = 1
  }

  tags = {
    Name = "${local.App}_instance_app"
    App  = local.App
  }
  volume_tags = {
    Name = "${local.App}_block_instance_app"
    App  = local.App
  }
}

resource "aws_instance" "db" {
  ami                  = var.ami
  availability_zone    = var.availability_zone
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.db.name
  user_data_base64     = data.cloudinit_config.db.rendered

  network_interface {
    network_interface_id = aws_network_interface.db2ngw.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.db2app.id
    device_index         = 1
  }

  tags = {
    Name = "${local.App}_instance_db"
    App  = local.App
  }
  volume_tags = {
    Name = "${local.App}_block_instance_db"
    App  = local.App
  }
}
