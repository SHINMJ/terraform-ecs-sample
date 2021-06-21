name                = "demo"
environment         = "stage"
availability_zones  = ["ap-northeast-2a", "ap-northeast-2c"]
private_subnets     = ["10.0.0.0/20", "10.0.32.0/20"]
public_subnets      = ["10.0.16.0/20", "10.0.48.0/20"]
tsl_certificate_arn = "certificatearn"
container_memory    = 512
dockerfile_dir      = "../app"