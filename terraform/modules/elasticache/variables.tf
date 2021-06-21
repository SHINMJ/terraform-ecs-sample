variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

// ElastiCache
// http://docs.aws.amazon.com/cli/latest/reference/elasticache/create-cache-cluster.html

variable elasticache_engine_version {
  description = "Specifies the engine version for the cache instance."
  default = "2.8.24"
}

variable elasticache_maintenance_window {
  description = "Specifies the maintenence window for the cache instance."
  default = "sun:05:00-sun:09:00"
}

variable elasticache_instance_type {
  description = "Specifies the instance type for the cache instance."
  default = "cache.t2.micro"
}

variable "elasticache_port" {
  description = "The elasticache port."
}

variable "subnets" {
  description = "Public subnet"
}

variable "elasticache_security_groups_id" {
  description = "security groups id for elasticache"
}