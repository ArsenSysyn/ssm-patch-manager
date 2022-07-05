variable "patch_group_name" {
    description = "Patch Group Name"
    type = string
}

variable "maintenance_window_name" {
    description = "Maintenance Window Name"
    type = string
    default = "MaintenanceWindow"
}

variable "cron_schedule" {
    description = "Schedule your patching, using format cron(00 06 ? * * *) - it is 06:00 UTC everyday"
    type = string
    default = "cron(00 06 ? * * *)" 
}

variable "duration_of_maintenance" {
    description = "Specify a duration of your maintenance window"
    type = number
    default = 1
}

variable "cutoff" {
    description = "Specify a cutoff time"
    type = number
    default = 0
}

variable "priority" {
    description = "Specify a priority of patching task"
    type = number
    default = 1
}

variable "max_concurrency" {
    description = "Specify the Max. number of concurrency patching tasks"
    type = number
    default = 3
}

variable "max_errors" {
    description = "Specify the number of errors to stop patching"
    type = number
    default = 3
}

variable "owner" {
    description = "Specify the owner of Patch Baseline, it can be AWS or Self"
    type = string
    default = "AWS"
}

variable "name_prefix" {
    description = "Specify the name prefix of the Patch Baseline which you want to apply"
    type = string
    default = "AWS-WindowsPredefinedPatchBaseline-OS-Applications"
}

variable "operating_system" {
    description = "Specify operation system of the Patch Baseline which you want to apply"
    type = string
    default = "WINDOWS"
}