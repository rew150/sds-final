resource "aws_iam_instance_profile" "app" {
  name = "${local.App}_app_instance_profile"
  role = aws_iam_role.app.name

  tags = {
    Name = "${local.App}_instance_profile_app"
    App  = local.App
  }
}

resource "aws_iam_instance_profile" "db" {
  name = "${local.App}_db_instance_profile"
  role = aws_iam_role.db.name

  tags = {
    Name = "${local.App}_instance_profile_db"
    App  = local.App
  }
}

data "aws_iam_policy_document" "ec2" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "app" {
  name               = "${local.App}_app_iam_role"
  path               = "/${local.App}/"
  assume_role_policy = data.aws_iam_policy_document.ec2.json

  tags = {
    Name = "${local.App}_iam_role_app"
    App  = local.App
  }
}

resource "aws_iam_role" "db" {
  name               = "${local.App}_db_iam_role"
  path               = "/${local.App}/"
  assume_role_policy = data.aws_iam_policy_document.ec2.json

  tags = {
    Name = "${local.App}_iam_role_db"
    App  = local.App
  }
}

data "aws_iam_policy" "mng" {
  name = "AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "app_mng" {
  role       = aws_iam_role.app.name
  policy_arn = data.aws_iam_policy.mng.arn
}

resource "aws_iam_role_policy_attachment" "db_mng" {
  role       = aws_iam_role.db.name
  policy_arn = data.aws_iam_policy.mng.arn
}
