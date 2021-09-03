resource "aws_acm_certificate" "gitlab" {
  domain_name       = "gitlab.${var.domain_root}"
  validation_method = "DNS"

  tags = merge(
    {
      Name = "Gitlab Certificate"
    },
    local.common_tags
  )
}

resource "aws_acm_certificate_validation" "gitlab_ssl_cert_validation" {
  certificate_arn         = aws_acm_certificate.gitlab.arn
  validation_record_fqdns = [aws_route53_record.gitlab_ssl_cert_validation.fqdn]
}

resource "aws_route53_record" "gitlab_ssl_cert_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.gitlab.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.gitlab.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.gitlab.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.main.id
  ttl             = 60 * 10
}