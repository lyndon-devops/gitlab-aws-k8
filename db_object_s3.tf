
resource "aws_s3_bucket" "storage_lfs" {
  bucket = "${var.domain_root}.gitlab.lfs"
}

resource "aws_s3_bucket" "storage_artifacts" {
  bucket_prefix = "${var.domain_root}.gitlab.artifacts"
}

resource "aws_s3_bucket" "storage_uploads" {
  bucket = "${var.domain_root}.gitlab.uploads"
}

resource "aws_s3_bucket" "storage_packages" {
  bucket = "${var.domain_root}.gitlab.packages"
}

resource "aws_s3_bucket" "storage_backups" {
  bucket = "${var.domain_root}.gitlab.backups"
}

resource "aws_s3_bucket" "storage_temp_bucket" {
  bucket = "${var.domain_root}.gitlab.backups.temp"
}

resource "aws_s3_bucket" "storage_external_diffs" {
  bucket = "${var.domain_root}.gitlab.external.diffs"
}

resource "aws_s3_bucket" "storage_terraform_state" {
  bucket = "${var.domain_root}.gitlab.terraform"
}

resource "aws_s3_bucket" "storage_dependency_proxy" {
  bucket = "${var.domain_root}.gitlab.dependency.proxy"
}