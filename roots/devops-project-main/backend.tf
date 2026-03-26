terraform {
  required_version = ">= 1.6.6"

  backend "s3" {
    bucket         = "060623762260-projectx-tfstate"
    key            = "projectx/devops-project-main/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "060623762260-terraform-lock-dev"
  }
}