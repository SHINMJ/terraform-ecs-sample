resource "aws_db_subnet_group" "rds_subnet" {
  name                   = "${var.name}-rds-subnet-${var.environment}"
  description            = "RDS subnet group"
  subnet_ids             = var.private_subnets.*.id
}

# rds pg
# mariadb 기준. character set = utf-8, timezone = Asia/Seoul, autocommit = false
resource "aws_db_parameter_group" "mariadb_default" {
  name = "${var.name}-mariadb-pg-${var.environment}"
  description = "The Parameter group for mariadb"
  family = var.rds_pg_family

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }

  parameter {
    name = "autocommit"
    value = 0
  }

  parameter {
    name = "time_zone"
    value = "Asia/Seoul"
  }

  tags = {
    Name        = "${var.name}-mariadb-pg-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier             = "${var.name}-rds-${var.environment}"
  allocated_storage      = var.rds_allocated_storage
  engine                 = var.rds_engine
  engine_version         = var.rds_engine_version
  instance_class         = var.rds_instance_class
  name                   = var.database_name
  username               = var.database_user
  password               = var.database_password
  vpc_security_group_ids = [var.rds_security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.id
  parameter_group_name   = aws_db_parameter_group.mariadb_default.id
  storage_type           = var.rds_storage_type
  storage_encrypted      = false
  skip_final_snapshot    = true
  publicly_accessible    = true
  multi_az               = false
    
  tags = {
    Name        = "${var.name}-rds-${var.environment}"
    Environment = var.environment
  }
}

output "rds_endpoint" {
  value = aws_db_instance.rds_instance.address
}