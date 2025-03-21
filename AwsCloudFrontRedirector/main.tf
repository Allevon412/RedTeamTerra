# it is required to use the us-east-1 region for the ACM certificate
# this is because the CloudFront service must use certificates within the us-east-1 region. It is a requirement by AWS.
resource "aws_acm_certificate" "cf-cdn-to-redirector-cert" {
  domain_name = var.alternate_domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Environment = "production redirector"
  }
}

data "cloudflare_zone" "data_bread-man_org" {
  filter = {
    name = var.domain_name_for_cdn
  }
}

resource "cloudflare_dns_record" "bread-man_org" {
  for_each = {
    for dvo in aws_acm_certificate.cf-cdn-to-redirector-cert.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      value = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }

  zone_id = data.cloudflare_zone.data_bread-man_org.zone_id
  name = each.value.name
  content = each.value.value
  type = each.value.type
  ttl = 60
  proxied = false

}

resource "aws_acm_certificate_validation" "cf-cdn-to-redirector-cert" {
  certificate_arn         = aws_acm_certificate.cf-cdn-to-redirector-cert.arn
  validation_record_fqdns = [for record in cloudflare_dns_record.bread-man_org : record.name]
}
# obtain the cache policy and origin request policy from AWS
data "aws_cloudfront_cache_policy" "Managed-CacheDisabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "Managed-AllViewer" {
  name = "Managed-AllViewer"
}

# create a distribution in AWS CloudFront that points to our redirector server. with a custom AWS signed certificate.
resource "aws_cloudfront_distribution" "cf_cdn_to_redirector" {
  origin {
    domain_name = var.redirector
    origin_id = "redirector_origin"

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }
  enabled = true
  is_ipv6_enabled = true
  comment = "CDN to redirector"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations = ["US"]
    }
  }
  aliases = [var.alternate_domain_name]

  default_cache_behavior {
    allowed_methods        = ["GET","HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["HEAD", "GET"]
    target_origin_id       = "redirector_origin"
    viewer_protocol_policy = "allow-all"
    min_ttl = 0
    default_ttl = 0
    max_ttl = 0
    compress = false
    # TODO resolve these programmatically
    cache_policy_id = data.aws_cloudfront_cache_policy.Managed-CacheDisabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.Managed-AllViewer.id
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }


  }

  /*
  to do make the cache policy and origin request policy
  UseOriginCacheControlHeaders & Managed-AllViewer
  */

  price_class = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cf-cdn-to-redirector-cert.arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }
}

# finally, create a CNAME record in Cloudflare to point to the CloudFront distribution domain name provided by AWS.
resource cloudflare_dns_record "cname_pointing_to_cdn" {
  zone_id = data.cloudflare_zone.data_bread-man_org.zone_id
  name = var.alternate_domain_name
  content = aws_cloudfront_distribution.cf_cdn_to_redirector.domain_name
  type = "CNAME"
  ttl = 60
  proxied = false

}