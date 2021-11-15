resource "aws_ssm_document" "cloud_init_wait" {
  name            = "${local.App}_cloud_init_wait_ssm_doc"
  document_type   = "Command"
  document_format = "YAML"
  content         = <<-DOC
    schemaVersion: '2.2'
    description: Wait for cloud init to finish
    mainSteps:
    - action: aws:runShellScript
      name: StopOnLinux
      precondition:
        StringEquals:
        - platformType
        - Linux
      inputs:
        runCommand:
        - cloud-init status --wait
    DOC

  tags = {
    Name = "${local.App}_ssm_doc_cloud_init_wait"
    App  = local.App
  }
}
