# Terraform ECS Fargate

Terraform을 사용하여 AWS Resource 프로비저닝 하는 법.

- Terraform v0.14.8
  - provider registry.terraform.io/hashicorp/aws v3.33.0

## Toc

- [Terraform ECS Fargate](#terraform-ecs-fargate)
  - [Toc](#toc)
  - [Resource](#resource)
  - [Prerequsite](#prerequsite)
  - [Usage](#usage)
  - [Reference](#reference)
  - [TODO](#todo)

## Resource

- VPC
- AZ(a,c) 각 public, private subnet
- Routing tables for the subnets
- Internet Gateway for public subnets
- NAT gateway + Elastic IPs for private subnet
- Security groups
  - HTTP/HTTPS access
  - container port access
  - RDS access
- ALB + Target group
- ECR
- ECS
- RDS(mariadb), Elastic Cache

## Prerequsite

- aws cli 2
- S3 bucket : terraform state backend
- IAM User : access key, secret key
- 배포할 소스 : django + docker
- ssl 인증서 : ssl 사용 시 필요. certification manager에 등록
- domain : 필요 시.

## Usage

1. 배포할 application 준비
2. aws provider 정보 세팅 - ex) secrets.tfvars.sample
3. resource 프로비저닝
   - ./terraform/main.tf 에 사용 리소스 정의
   ```sh
   cd terraform
   terraform init
   terraform plan -var-file=secrets.tfvars -out=out.plan
   terraform apply "out.plan"
   ```

## Reference

- [terraform best practice](https://medium.com/xebia-engineering/best-practices-to-create-organize-terraform-code-for-aws-2f4162525a1a) 참고.

## TODO

앞으로 필요한 리소스. 테라폼으로 관리 할 지에 대한 여부.

- Route53
- Cognito
- etc...
