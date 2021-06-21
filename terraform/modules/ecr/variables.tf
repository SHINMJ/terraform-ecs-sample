variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  default     = "stage"
}

# variable "region" {
#   description = "the AWS region in which resources are created, you must set the availability_zones variable as well if you define this value to something other than the default"
#   default     = "ap-northeast-2"
# }

# variable "aws-region" {
#   type        = string
#   description = "AWS region to launch servers."
#   default     = "ap-northeast-2"
# }

# variable "aws-access-key" {
#   type = string
# }

# variable "aws-secret-key" {
#   type = string
# }