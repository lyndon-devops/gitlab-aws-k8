resource "aws_rds_cluster" "main" {
  cluster_identifier = "${var.application_name}-aurora-cluster"

  //we cant use serverless at the moment due to postgres version requirements of gitlab
  engine_mode    = "provisioned"
  engine         = "aurora-postgresql"
  engine_version = "13.3"
  port           = 5432

  enable_http_endpoint = true

  database_name   = "postgres"
  master_username = "postgres"
  master_password = "secret123456postgres"

  vpc_security_group_ids = [module.vpc.default_security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.name
  availability_zones     = module.vpc.azs

  final_snapshot_identifier = "${var.application_name}-rds-final-snapshot-${formatdate("YYYYMMDDHHmm", timestamp())}"
  deletion_protection       = false
  backup_retention_period   = 7
  apply_immediately         = true

  tags = local.common_tags

  lifecycle {
    ignore_changes = [final_snapshot_identifier]
  }
}

resource "aws_db_subnet_group" "rds_subnet" {
  name       = "${var.application_name}--aurora-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = local.common_tags
}