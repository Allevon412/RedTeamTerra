resource "azurerm_cdn_frontdoor_rule_set" "RedirectorHardeningRuleSet" {
  name = "RedirectorHardeningRuleSet"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.FrontDoorRedirectorProfile.id
}

resource "azurerm_cdn_frontdoor_rule" "HardeningRule1" {
  name                      = "GeoLocationRestrictions"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.RedirectorHardeningRuleSet.id
  order                     = 1
  behavior_on_match         = "Stop"
  actions {
    url_redirect_action {
      redirect_type        = "PermanentRedirect"
      redirect_protocol    = "MatchRequest"
      query_string         = "search=q?rickrolled"
      destination_hostname = "www.google.com"
    }
  }

  conditions {
    remote_address_condition {
      operator         = "GeoMatch" #if the source of the request
      negate_condition = true # is not from
      match_values     = ["US"] # the us. Redirect to rickroll.
    }
  }
}

resource "azurerm_cdn_frontdoor_rule" "HardeningRule2" {
  name                      = "HeaderCheck"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.RedirectorHardeningRuleSet.id
  order                     = 2
  behavior_on_match         = "Stop"
  actions {
    url_redirect_action {
      redirect_type        = "PermanentRedirect"
      redirect_protocol    = "MatchRequest"
      query_string         = "search=q?rickrolled"
      destination_hostname = "www.google.com"
    }
  }

  conditions {
    request_header_condition {
      operator         = "Equal"
      negate_condition = true
      header_name = "Access-X-Control"
        match_values     = ["True"]
    }
  }
}