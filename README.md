# Module for providing basic Patch Managment for EC2



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
