provider "aws" {
    region = "us-east-1"
}

# Use case of module using default VPC and subnet
resource "aws_default_vpc" "default" {

}

resource "aws_default_subnet" "az1" {
  availability_zone = "us-east-1a"
}

module "rdp" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"
  name = "RDP_Connection"
  vpc_id = aws_default_vpc.default.id
  ingress_with_cidr_blocks = [
    {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      description = "RDP"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules = ["all-all"]
}

module "ec2_windows" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.0.0"

  for_each = toset(["1", "2"])

  name = "Windows server ${each.key}"
  ami                    = data.aws_ami.windows2019.id
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = [module.rdp.security_group_id]
  subnet_id              = aws_default_subnet.az1.id
  iam_instance_profile = "ForSSMRole"
  tags = {
    "Patch Group" = var.patch_group_name
  }
}

module "patch-manager" {
    source = "github.com/ArsenSysyn/ssm-patch-manager"
    patch_group_name = var.patch_group_name
    cron_schedule = var.cron_schedule
    max_errors = 3
  
}