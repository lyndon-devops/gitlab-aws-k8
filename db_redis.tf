resource "aws_elasticache_cluster" "main" {
  depends_on = [aws_elasticache_subnet_group.redis_subnet]

  cluster_id     = "${var.application_name}-redis-cluster"
  engine         = "redis"
  engine_version = "3.2.10"

  node_type            = "cache.t3.medium"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"

  port               = 6379
  subnet_group_name  = aws_elasticache_subnet_group.redis_subnet.name
  security_group_ids = [module.vpc.default_security_group_id]

  tags = local.common_tags

  lifecycle {
    ignore_changes = [node_type, num_cache_nodes]
  }
}

resource "aws_elasticache_subnet_group" "redis_subnet" {
  name       = "${var.application_name}-redis-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = local.common_tags
}