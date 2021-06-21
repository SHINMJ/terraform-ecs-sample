variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

// RDS
// https://docs.aws.amazon.com/AmazonRDS/latest/CommandLineReference/CLIReference-cmd-CreateDBInstance.html

variable "rds_pg_family" {
  description = "The family of the DB parameter group"
  default = "mariadb10.4"
}

variable rds_allocated_storage {
  description = "Amount of storage to be initially allocated for the DB instance, in gigabytes."
  default = 5
}

variable rds_engine {
  description = "Name of the database engine to be used for this instance."
  default = "mariadb"
}

variable rds_engine_version {
  description = "Version number of the database engine to use."
  default = "10.4.13"
}

variable rds_instance_class {
  description = "The compute and memory capacity of the instance"
  default = "db.t2.micro"
}

variable database_name {
  description = "The name of the database."
}

variable database_user {
  description = "The name of the master database user."
}

variable database_password {
  description = "Password for the master DB instance user"
}

variable rds_storage_type {
  description = "Specifies the storage type for the DB instance."
  default = "standard"
}

variable "rds_security_group_id" {
  description = "The security group id for rds"
}

variable "public_subnets" {
  description = "Public subnet"
}

variable "private_subnets" {
  description = "Private subnet"
}