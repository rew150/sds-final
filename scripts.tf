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
