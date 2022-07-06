# Module for providing basic Patch Managment for EC2

By default this module provide configured patch managment for Windows Platforms with patch baseline "AWS-WindowsPredefinedPatchBaseline-OS-Applications". Patching starts everyday 06:00 UTC.

## Usage:

```
module "patch-manager" {
    source = "github.com/ArsenSysyn/ssm-patch-manager"
    patch_group_name = var.patch_group_name
    cron_schedule = var.cron_schedule
}
```

---

## Required inputs

__patch_group_name__(string)

Description: specify Patch Group name which will be created. And this name you need to specify for AWS EC2 instance as a tag with key "Patch Group"

---

## Optional inputs

__maintenance_window_name__(string)

Description: specify maintenance window name

default: `MaintenanceWindow`


__cron_schedule__(string)

Description: schedule your patching, using format cron(00 06 ? * * *) - it is 06:00 UTC everyday

default: `cron(00 06 ? * * *)`


__duration_of_maintenance__(number)

Description: specify a duration of your maintenance window

default: `1`


__cutoff__(number)

Description: specify a cutoff time

default: `0`


__priority__(number)

Description: specify a priority of patching task

default: `1`


__max_concurrency__(number)

Description: specify the Max. number of concurrency patching tasks

default: `3`


__max_errors__(number)

Description: specify the number of errors to stop patching

default: `3`


__owner__(string)

Description: specify the owner of Patch Baseline, it can be AWS or Self

default: 'AWS'


__name_prefix__(string)

Description: specify the name prefix of the Patch Baseline which you want to apply

default: 'AWS-WindowsPredefinedPatchBaseline-OS-Applications'


__operating_system__(string)

Description: specify operation system of the Patch Baseline which you want to apply

default: 'WINDOWS'


---

## Outputs

No outputs.


__ATTENTION__

The patching performed to the patch group. So you need to add instance to this patch group. There are 2 requirements:
1. Tag for your instance "Patch Group" : "name of your patch group"
2. Role for EC2 in order to give connectivity SSM Patch Manager to EC2. We need to attach this role to EC2.
In AWS we have this permission with name __AmazonSSMManagedInstanceCore__, or you can just copy JSON
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeAssociation",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:GetDocument",
                "ssm:DescribeDocument",
                "ssm:GetManifest",
                "ssm:GetParameter",
                "ssm:GetParameters",
                "ssm:ListAssociations",
                "ssm:ListInstanceAssociations",
                "ssm:PutInventory",
                "ssm:PutComplianceItems",
                "ssm:PutConfigurePackageResult",
                "ssm:UpdateAssociationStatus",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2messages:AcknowledgeMessage",
                "ec2messages:DeleteMessage",
                "ec2messages:FailMessage",
                "ec2messages:GetEndpoint",
                "ec2messages:GetMessages",
                "ec2messages:SendReply"
            ],
            "Resource": "*"
        }
    ]
}
```
