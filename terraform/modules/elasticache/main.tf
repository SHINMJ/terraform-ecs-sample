resource "aws_elasticache_cluster" "redis" {
  cluster_id            = "${var.name}-redis-${var.environment}"
  engine                = "redis"
  engine_version        = var.elasticache_engine_version
  maintenance_window    = var.elasticache_maintenance_window
  node_type             = var.elasticache_instance_type
  num_cache_nodes       = "1"
  parameter_group_name  = "default.redis2.8"
  port                  = var.elasticache_port
  subnet_group_name     = aws_elasticache_subnet_group.default.name
  security_group_ids    = [var.elasticache_security_groups_id]

  tags = {
    Name        = "${var.name}-elasicache-${var.environment}"
    Environment = var.environment
  }
  
}

resource "aws_elasticache_subnet_group" "default" {
  name = "${var.name}-elasticache-subnet-group-${var.environment}"
  description = "Private subnets for the ElastiCache instances"
  subnet_ids = var.subnets.*.id
}
