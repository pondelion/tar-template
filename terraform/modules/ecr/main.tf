resource "aws_ecr_repository" "app_runner_image" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "repo_url" {
  value = aws_ecr_repository.app_runner_image.repository_url
}

output "registry_id" {
  value = aws_ecr_repository.app_runner_image.registry_id
}
