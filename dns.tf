data "aws_route53_zone" "main" {
  name         = var.domain_root
  private_zone = false
}