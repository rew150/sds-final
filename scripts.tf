data "cloudinit_config" "app" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/scripts/common.tpl", {})
  }

  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/scripts/app.tpl", {})
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile(
      "${path.module}/scripts/app.sh.tpl",
      {
        database_host = aws_network_interface.db2app.private_ip
        database_name = var.database_name
        database_user = var.database_user
        database_pass = var.database_pass
        admin_user    = var.admin_user
        admin_pass    = var.admin_pass
      }
    )
  }
}

data "cloudinit_config" "db" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/scripts/common.tpl", {})
  }

  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/scripts/db.tpl", {})
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile(
      "${path.module}/scripts/db.sh.tpl",
      {
        database_name = var.database_name
        database_user = var.database_user
        database_pass = var.database_pass
      }
    )
  }
}
