
### ECR ###

module "app_runner_ecr" {
  source = "./modules/ecr"
  name = "terraform-app-runner-test"
}

# docker build

data "archive_file" "docker" {
  type        = "zip"
  source_dir  = var.dockerfile_dir
  output_path = "docker_files.zip"
}

resource "null_resource" "app_runner_docker_build" {
  triggers = {
    src_hash = "${data.archive_file.docker.output_sha}"
  }

  provisioner "local-exec" {
    command = "sh ${var.dockerbuild_sh_filepath}"

    environment = {
      AWS_REGION     = var.region
      AWS_ACCOUNT_ID = module.app_runner_ecr.registry_id
      REPO_URL       = module.app_runner_ecr.repo_url
      CONTAINER_NAME = "terraform-app-runner-test"
      DOCKERFILE_DIR = var.dockerfile_dir
    }
  }
}

### App Runner ###

data "aws_iam_policy" "apprunner_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

module "app_runner_role" {
  source = "./modules/iam"
  name = "terraform-app-runner-test-role"
  identifiers = [
    "build.apprunner.amazonaws.com",
    "tasks.apprunner.amazonaws.com"
  ]
  policy = data.aws_iam_policy.apprunner_policy.policy
}

data "aws_iam_policy_document" "instance_policy_doc" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "s3:*",
    ]
  }
}

module "instance_role" {
  source = "./modules/iam"
  name = "terraform-app-runner-instance-test-role"
  identifiers = [
    "build.apprunner.amazonaws.com",
    "tasks.apprunner.amazonaws.com"
  ]
  policy = data.aws_iam_policy_document.instance_policy_doc.json
}

module "app_runner_service" {
  source = "./modules/apprunner"
  name = "terraform-app-runner-test"
  iam_role_arn = module.app_runner_role.iam_role_arn
  image_uri = "${module.app_runner_ecr.repo_url}:latest"
  port = 80
  cpu = 1024
  memory = 2048
  instance_role_arn = module.instance_role.iam_role_arn
}

output "app_runner_service_url" {
  value = module.app_runner_service.app_runner_service_url
}

output "app_runner_service_status" {
  value = module.app_runner_service.app_runner_service_status
}