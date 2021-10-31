resource "aws_security_group" "app2gw" {
  name   = "app2gw"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description      = "ICMP"
    from_port        = 8
    to_port          = 0
    protocol         = "icmp"
    cidr_blocks      = [var.vpc_cidr]
    ipv6_cidr_blocks = []
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description      = "ICMP"
    from_port        = 8
    to_port          = 0
    protocol         = "icmp"
    cidr_blocks      = [var.vpc_cidr]
    ipv6_cidr_blocks = []
  }

  egress {
    description      = "wildcard"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.App}_secgrp_app2gw"
    App  = local.App
  }
}

resource "aws_security_group" "app2db" {
  name   = "app2db"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description      = "ICMP"
    from_port        = 8
    to_port          = 0
    protocol         = "icmp"
    cidr_blocks      = [module.subnet_addrs.network_cidr_blocks[local.dbconn_subnet]]
    ipv6_cidr_blocks = []
  }

  egress {
    description      = "ICMP"
    from_port        = 8
    to_port          = 0
    protocol         = "icmp"
    cidr_blocks      = [var.vpc_cidr]
    ipv6_cidr_blocks = []
  }

  egress {
    description = "MariaDB"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [module.subnet_addrs.network_cidr_blocks[local.dbconn_subnet]]
  }

  tags = {
    Name = "${local.App}_secgrp_app2db"
    App  = local.App
  }
}

resource "aws_security_group" "db2app" {
  name   = "db2app"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description      = "ICMP"
    from_port        = 8
    to_port          = 0
    protocol         = "icmp"
    cidr_blocks      = [module.subnet_addrs.network_cidr_blocks[local.dbconn_subnet]]
    ipv6_cidr_blocks = []
  }

  ingress {
    description = "MariaDB"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [module.subnet_addrs.network_cidr_blocks[local.dbconn_subnet]]
  }

  egress {
    description      = "ICMP"
    from_port        = 8
    to_port          = 0
    protocol         = "icmp"
    cidr_blocks      = [var.vpc_cidr]
    ipv6_cidr_blocks = []
  }

  tags = {
    Name = "${local.App}_secgrp_db2app"
    App  = local.App
  }
}

resource "aws_security_group" "db2ngw" {
  name   = "db2ngw"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "ICMP"
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
  }

  egress {
    description = "ICMP"
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
  }

  egress {
    description      = "wildcard"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.App}_secgrp_db2ngw"
    App  = local.App
  }
}
