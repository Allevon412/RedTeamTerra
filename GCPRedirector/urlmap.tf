resource "google_compute_url_map" "cdn_url_map" {
  name = "cdn-lb" #this is the name of the load balancer.
  default_service = google_compute_backend_service.redirector_backend_service.self_link
  project = var.project_id
}