resource "aws_rds_cluster" "main" {
  cluster_identifier = "${var.application_name}-aurora-cluster"

  engine_mode    = "serverless"
  engine         = "aurora-postgresql"
  engine_version = "10.14"
  port           = 5432

  enable_http_endpoint = true

  scaling_configuration {
    auto_pause               = true
    max_capacity             = 64
    min_capacity             = 2
    seconds_until_auto_pause = 1500
    timeout_action           = "ForceApplyCapacityChange"
  }

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