locals {
  kubernetes_secret_credentials_name = "database-details"
  kubernetes_secret_credentials_password = "password"
}

resource "helm_release" "application_api" {
  name     = "gitlab"
  repository = "https://charts.gitlab.io/"
  chart    = "gitlab/gitlab"
  version  = "5.2.3"

  //database
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

  //cache
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

  //object storage
  //https://gitlab.com/gitlab-org/charts/gitlab/blob/master/examples/values-external-objectstorage.yaml
  //https://gitlab.com/gitlab-org/charts/gitlab/blob/master/doc/charts/globals.md#connection
  set {
    name = "global.minio.enabled"
    value = "false"
  }

  set {
    name = "global.appConfig.lfs.bucket"
    value = aws_s3_bucket.storage_lfs.bucket
  }

  set {
    name = "global.appConfig.artifacts.bucket"
    value = aws_s3_bucket.storage_artifacts.bucket
  }

  set {
    name = "global.appConfig.uploads.bucket"
    value = aws_s3_bucket.storage_uploads.bucket
  }

  set {
    name = "global.appConfig.packages.bucket"
    value = aws_s3_bucket.storage_packages.bucket
  }

  set {
    name = "global.appConfig.backups.bucket"
    value = aws_s3_bucket.storage_backups.bucket
  }

  set {
    name = "global.appConfig.backups.tmpBucket"
    value = aws_s3_bucket.storage_temp_bucket.bucket
  }

  set {
    name = "global.appConfig.externalDiffs.bucket"
    value = aws_s3_bucket.storage_external_diffs.bucket
  }

  set {
    name = "global.appConfig.terraformState.bucket"
    value = aws_s3_bucket.storage_terraform_state.bucket
  }

  set {
    name = "global.appConfig.dependencyProxy.bucket"
    value = aws_s3_bucket.storage_dependency_proxy.bucket
  }

  //dns and lb settings
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