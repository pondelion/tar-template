
resource "aws_apprunner_service" "main" {
  service_name = var.name

  source_configuration {
    authentication_configuration {
      access_role_arn = var.iam_role_arn
    }
    image_repository {
      image_configuration {
        port = "${var.port}"
      }
      image_identifier        = var.image_uri
      image_repository_type   = var.image_repository_type
    }
    auto_deployments_enabled = true
  }

  instance_configuration {
    cpu = var.cpu
    memory = var.memory
    instance_role_arn = var.instance_role_arn
  }
}

output "app_runner_service_url" {
  value = aws_apprunner_service.main.service_url
}

output "app_runner_service_status" {
  value = aws_apprunner_service.main.status
}
