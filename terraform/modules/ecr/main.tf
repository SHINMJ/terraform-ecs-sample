# provider "aws" {
#   access_key = var.aws-access-key
#   secret_key = var.aws-secret-key
#   region     = var.aws-region
# }

# # backend
# terraform {
#   backend "s3" {
#     bucket  = "terraform-backend-store-test"
#     encrypt = true
#     key     = "terraform.tfstate"
#     region  = "ap-northeast-2"
#   }
# }

# repository
resource "aws_ecr_repository" "main" {
  name                 = "${var.name}-${var.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

# policy
resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 10 images"
      action       = {
        type = "expire"
      }
      selection     = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}

resource "aws_ecr_repository_policy" "main" {
  repository = aws_ecr_repository.main.name
  policy = jsonencode({
    Version     = "2008-10-17"
    Statement   = [{
      Sid       = "adds full ecr access to the repository"
      Effect    = "Allow"
      Principal = "*"
      Action    = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetLifecyclePolicy",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ]
    }]
  })
}

output "aws_ecr_repository_url" {
    value = aws_ecr_repository.main.repository_url
}