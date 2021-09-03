locals {
  kubernetes_secret_credentials_name = "database-details"
  kubernetes_secret_credentials_password = "password"
}

resource "helm_release" "application_api" {
  name     = "gitlab"
  chart    = "gitlab/gitlab"

  //https://docs.gitlab.com/charts/advanced/external-db/index.html
  set {
    name = "postgresql.install"
    value = "false"
  }

  set {
    name = "global.psql.host"
    value = aws_rds_cluster.main.endpoint
  }

  set {
    name = "global.psql.database"
    value = aws_rds_cluster.main.database_name
  }

  set {
    name = "global.psql.username"
    value = aws_rds_cluster.main.master_username
  }

  set {
    name = "global.psql.password.secret"
    value = local.kubernetes_secret_credentials_name
  }

  set {
    name = "global.psql.password.key"
    value = local.kubernetes_secret_credentials_password
  }

  //https://docs.gitlab.com/charts/advanced/external-redis/index.html
  set {
    name = "redis.install"
    value = "false"
  }

  set {
    name = "global.redis.host"
    value = aws_elasticache_cluster.main.cache_nodes.0.address
  }

  set {
    name = "global.redis.password.enabled"
    value = "false"
  }

  set {
    name = "global.hosts.domain"
    value = aws_acm_certificate.gitlab.domain_name
  }

  set {
    name = "global.hosts.https"
    value = "true"
  }

  set {
    name  = "global.ingress.annotations.\"service.beta.kubernetes.io/aws-load-balancer-backend-protocol\""
    value = "http"
  }

  set {
    name  = "global.ingress.annotations.\"service.beta.kubernetes.io/aws-load-balancer-ssl-cert\""
    value = aws_acm_certificate.gitlab.arn
  }

  set {
    name  = "global.ingress.annotations.\"service.beta.kubernetes.io/aws-load-balancer-ssl-ports\""
    value = "https"
  }

  depends_on = [
    aws_acm_certificate_validation.gitlab_ssl_cert_validation,
    aws_rds_cluster.main
  ]
}

resource "kubernetes_secret" "database_credentials" {
  metadata {
    name = local.kubernetes_secret_credentials_name
  }

  data = {
    "${local.kubernetes_secret_credentials_password}" = aws_rds_cluster.main.master_password
  }
}