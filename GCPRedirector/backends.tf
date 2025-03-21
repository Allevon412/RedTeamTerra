resource "google_compute_global_network_endpoint_group" "redirector_endpoint_group" {
  name = "redirector-group"
  network_endpoint_type = "INTERNET_FQDN_PORT"
}

resource "google_compute_global_network_endpoint" "redirector_endpoint" {
  global_network_endpoint_group = google_compute_global_network_endpoint_group.redirector_endpoint_group.id
  fqdn = var.redirector_domain
  port = 443

}

resource "google_compute_backend_service" "redirector_backend_service" {
  name = "redirector-backend-service"
  protocol = "HTTPS"
  timeout_sec = 10
  port_name = "https"
  enable_cdn = true
  compression_mode = "DISABLED"

  cdn_policy {
    cache_key_policy {
      include_host = false
      include_protocol = false
      include_query_string = false
    }
    cache_mode = "CACHE_ALL_STATIC"
    default_ttl = 0
    max_ttl = 0
    client_ttl = 0
  }

  backend {
    group = google_compute_global_network_endpoint_group.redirector_endpoint_group.id
  }
}