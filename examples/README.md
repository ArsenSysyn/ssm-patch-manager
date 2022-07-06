# Example of usage module with Windows and Linux instances 

## Windows

There you can a infrastructure with 2 Windows 2019 machines, and we schedule patching 09:55 UTC everyday. I add to these instances tag with Key: `Patch Group`, and Value: `PatchGroupWin2019Prod`

```
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
    "Patch Group" = "PatchGroupWin2019Prod"
  }
}

module "patch-manager" {
    source = "github.com/ArsenSysyn/ssm-patch-manager"
    patch_group_name = "PatchGroupWin2019Prod"
    cron_schedule = var.cron_schedule
}
```
And on the screenshot you can see succes result of patching these instaces.

![image](/examples/screenshots/firstscreen.png)
## Linux

For Linux we can use the same code but with some changes. There infrastructure with the same, but we replaced Windows 2019 for Ubuntu 20.04 LTS.

When we want to use another operation system then Windows(it stay by default) we need to specify `operating_system` and `name_prefix` variables.


```
provider "aws" {
    region = "us-east-1"
}

# Use case of module using default VPC and subnet
resource "aws_default_vpc" "default" {

}

resource "aws_default_subnet" "az1" {
  availability_zone = "us-east-1a"
}

module "ssh" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"
  name = "SSH"
  vpc_id = aws_default_vpc.default.id
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules = ["all-all"]
}

module "ec2_windows" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.0.0"

  for_each = toset(["1", "2"])

  name = "Linux server ${each.key}"
  ami                    = data.aws_ami.ubuntu2004.id
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = [module.ssh.security_group_id]
  subnet_id              = aws_default_subnet.az1.id
  iam_instance_profile = "ForSSMRole"
  tags = {
    "Patch Group" = "PatchGroupLinux2004Prod"
  }
}

module "patch-manager" {
    source = "github.com/ArsenSysyn/ssm-patch-manager"
    patch_group_name = "PatchGroupLinux2004Prod"
    cron_schedule = "cron(55 09 ? * * *)"
    operating_system = "UBUNTU" 
    name_prefix = "AWS-UbuntuDefaultPatchBaseline"
}
```