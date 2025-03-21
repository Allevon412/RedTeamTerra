output "zone_id" {
  value = data.cloudflare_zone.data_bread-man_org.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.cf_cdn_to_redirector.domain_name
}

output "cname_records_from_cloudfront" {
  value = [for dvo in aws_acm_certificate.cf-cdn-to-redirector-cert.domain_validation_options : dvo.resource_record_name]
}