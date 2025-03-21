resource "google_compute_managed_ssl_certificate" "cdn_certificate" {
  project = var.project_id
  name = "cdn-certificate"
    managed {
        domains = [var.cloudfront_domain]
    }
}

resource "google_compute_target_https_proxy" "cdn_https_proxy" {
  project = var.project_id
  name = "cdn-https-proxy"
  ssl_certificates = [google_compute_managed_ssl_certificate.cdn_certificate.self_link]
  url_map = google_compute_url_map.cdn_url_map.self_link
}