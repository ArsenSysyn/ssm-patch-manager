data "aws_ssm_patch_baseline" "baseline" {
  owner            = var.owner
  name_prefix      = var.name_prefix
  operating_system = var.operating_system
}
