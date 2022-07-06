variable "patch_group_name" {
    default = "PatchGroupWin2019Prod"
}

variable "cron_schedule" {
    default = "cron(55 09 ? * * *)"
}