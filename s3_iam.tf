resource "aws_iam_policy" "s3" {
  name = "${local.App}_s3_iam_policy"
  path = "/${local.App}/"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "s3:*"
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.s3.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.s3.bucket}/*"
        ]
      }
    ]
  })

  tags = {
    Name = "${local.App}_iam_policy_s3"
    App  = local.App
  }
}

resource "aws_iam_user" "s3" {
  name                 = "${local.App}_s3_iam_user"
  path                 = "/${local.App}/"
  permissions_boundary = aws_iam_policy.s3.arn

  tags = {
    Name = "${local.App}_iam_user_s3"
    App  = local.App
  }
}

resource "aws_iam_user_policy_attachment" "s3" {
  user       = aws_iam_user.s3.name
  policy_arn = aws_iam_policy.s3.arn
}

resource "aws_iam_access_key" "s3" {
  user = aws_iam_user.s3.name
}
