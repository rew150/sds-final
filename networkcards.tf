resource "aws_network_interface" "app2gw" {
  subnet_id       = aws_subnet.public.id
  security_groups = [aws_security_group.app2gw.id]

  tags = {
    Name = "${local.App}_ni_app2gw"
    App  = local.App
  }
}

resource "aws_network_interface" "app2db" {
  subnet_id       = aws_subnet.dbconn.id
  security_groups = [aws_security_group.app2db.id]

  tags = {
    Name = "${local.App}_ni_app2db"
    App  = local.App
  }
}

resource "aws_network_interface" "db2app" {
  subnet_id       = aws_subnet.dbconn.id
  security_groups = [aws_security_group.db2app.id]

  tags = {
    Name = "${local.App}_ni_db2app"
    App  = local.App
  }
}

resource "aws_network_interface" "db2ngw" {
  subnet_id       = aws_subnet.private.id
  security_groups = [aws_security_group.db2ngw.id]

  tags = {
    Name = "${local.App}_ni_db2ngw"
    App  = local.App
  }
}

resource "aws_eip" "app" {
  vpc               = true
  network_interface = aws_network_interface.app2gw.id

  depends_on = [
    aws_internet_gateway.gw
  ]

  tags = {
    Name = "${local.App}_eip_app"
    App  = local.App
  }
}

output "app_eip" {
  value = aws_eip.app.public_ip
}
