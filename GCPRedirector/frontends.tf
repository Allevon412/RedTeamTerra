resource "google_compute_global_address" "cdn_public_address" {
  name = "cdn-public-address"
  project = var.project_id
  address_type = "EXTERNAL"
  description = "Global address for CDN"
}

resource "google_compute_global_forwarding_rule" "cdn_forwarding_rule" {
  name = "cdn-forwarding-rule"
  project = var.project_id
  target = google_compute_target_https_proxy.cdn_https_proxy.self_link
  ip_address = google_compute_global_address.cdn_public_address.address
  port_range = "443"
}


data "cloudflare_zone" "zone_data" {
  filter = {
    name = var.cloudfront_domain
  }
}

resource "cloudflare_dns_record" "cdn_record" {
  zone_id = data.cloudflare_zone.zone_data.zone_id
  name = var.cloudfront_domain
  content = google_compute_global_address.cdn_public_address.address
  type = "A"
  ttl = 60
  proxied = false
}