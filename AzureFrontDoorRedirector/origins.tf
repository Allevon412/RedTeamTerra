resource "azurerm_cdn_frontdoor_origin_group" "RedirectorOriginGroup" {
  name = "redirector-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.FrontDoorRedirectorProfile.id

  # can only be disabled if you have a single enabled origin in a single enabled origin group. This reduces load on application.
  # https://learn.microsoft.com/en-us/azure/frontdoor/health-probes
  health_probe {
    path = "/"
    protocol = "Https"
    interval_in_seconds = 255
    request_type = "HEAD"
  }

  load_balancing {
    sample_size = 4
    additional_latency_in_milliseconds = 50
    successful_samples_required = 3
  }

}

resource "azurerm_cdn_frontdoor_origin" "RedirectorOrigin" {
  name = "redirector-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.RedirectorOriginGroup.id
  enabled = true
  certificate_name_check_enabled = false
  host_name = var.redirector_domain
  origin_host_header = var.redirector_domain
  http_port = 80
  https_port = 443
  priority = 1
  weight = 1

}