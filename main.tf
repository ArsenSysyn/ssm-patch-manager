resource "aws_ssm_patch_group" "patchgroup" {
    baseline_id = data.aws_ssm_patch_baseline.baseline.id
    patch_group = var.patch_group_name
}

resource "aws_ssm_maintenance_window" "window" {
  name     = var.maintenance_window_name
  schedule = var.cron_schedule
  duration = var.duration_of_maintenance
  cutoff = var.cutoff
}

resource "aws_ssm_maintenance_window_target" "target" {
    window_id = aws_ssm_maintenance_window.window.id
    name = "MaintenanceTarget"
    resource_type = "INSTANCE"

    targets {
        key = "tag:Patch Group"
        values = [var.patch_group_name]
    }
}

resource "aws_ssm_maintenance_window_task" "patching" {
    window_id = aws_ssm_maintenance_window.window.id
    task_type = "RUN_COMMAND"
    task_arn = "AWS-RunPatchBaseline"
    priority = var.priority
    max_concurrency = var.max_concurrency
    max_errors = var.max_errors

    targets {
        key = "WindowTargetIds"
        values = [aws_ssm_maintenance_window_target.target.id]
    }

    task_invocation_parameters {
        run_command_parameters { 
            parameter {
                name = "Operation"
                values = ["Install"]
            }

        }

    }
}