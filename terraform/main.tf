provider "aws" {
  access_key = var.aws-access-key
  secret_key = var.aws-secret-key
  region     = var.aws-region
}

# backend
terraform {
  backend "s3" {
    bucket  = "terraform-backend-store-test"
    encrypt = true
    key     = "terraform.tfstate"
    region  = "ap-northeast-2"
  }
}

# codedeploy
# ec2 tag 지정 (example: ec2 instance name이 test-ec2인 인스턴스에만 적용.)
# module "codedeploy" {
#   source              = "./modules/codedeploy"
#   name                = var.name
#   autoscaling_groups  = ["autoscaling1", "autoscaling2"]
#   ec2_tag_filter      = {Name = "test-ec2"}
# }

# network
module "vpc" {
  source             = "./modules/network"
  name               = var.name
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
}

# security group
module "security_groups" {
  source            = "./modules/securitygroup"
  name              = var.name
  vpc_id            = module.vpc.id
  environment       = var.environment
  container_port    = var.container_port
  rds_port          = var.rds_port
  elasticache_port  = var.elasticache_port
}

# RDS
module "rds" {
  source                = "./modules/rds"
  name                  = var.name
  environment           = var.environment
  database_name         = var.database_name
  database_user         = var.database_user
  database_password     = var.database_password
  rds_security_group_id = module.security_groups.rds
  public_subnets        = module.vpc.public_subnets
  private_subnets       = module.vpc.private_subnets
}

# elasticache
module "elasticache" {
  source            = "./modules/elasticache"
  name              = var.name
  environment       = var.environment
  subnets           = module.vpc.public_subnets
  elasticache_security_groups_id  = module.security_groups.elasticache
  elasticache_port  = var.elasticache_port
}

# application loab balancer
module "alb" {
  source              = "./modules/alb"
  name                = var.name
  vpc_id              = module.vpc.id
  subnets             = module.vpc.public_subnets
  environment         = var.environment
  alb_security_groups = [module.security_groups.alb]
  # alb_tls_cert_arn    = var.tsl_certificate_arn
  health_check_path   = var.health_check_path
}

# ecr
module "ecr" {
  source          = "./modules/ecr"
  name            = var.name
  environment     = var.environment
}

# Builds sample django app and pushes it into aws_ecr_repository
resource "null_resource" "ecr_image" {
  provisioner "local-exec" {
    command = "bash ./bin/build.sh ${var.dockerfile_dir} ${module.ecr.aws_ecr_repository_url} ${var.container_image_tag} ${var.aws-region}"
  }
}

# ecs
module "ecs" {
  source                      = "./modules/ecs"
  name                        = var.name
  environment                 = var.environment
  region                      = var.aws-region
  subnets                     = module.vpc.private_subnets
  aws_alb_target_group_arn    = module.alb.aws_alb_target_group_arn
  ecs_service_security_groups = [module.security_groups.ecs_tasks]
  container_port              = var.container_port
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  container_image             = "${module.ecr.aws_ecr_repository_url}:${var.container_image_tag}"
  service_desired_count       = var.service_desired_count
  container_environment = [
    { name = "LOG_LEVEL",
    value = "DEBUG" },
    { name = "PORT",
    value = var.container_port }
  ]
  aws_ecr_repository_url = module.ecr.aws_ecr_repository_url
}