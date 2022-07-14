variable "name" {}
variable "iam_role_arn" {}
variable "image_uri" {}
variable "port" {}
variable "instance_role_arn" {}
variable "image_repository_type" {
  default = "ECR"
}
variable "cpu" {
  default = 1024
}
variable "memory" {
  default = 2048
}