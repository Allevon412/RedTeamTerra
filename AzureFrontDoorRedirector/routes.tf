resource "azurerm_cdn_frontdoor_route" "RedirectorRoute" {
  name = "RedirectorRoute"
  cdn_frontdoor_endpoint_id = azurerm_cdn_frontdoor_endpoint.RedirectorEndpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.RedirectorOriginGroup.id
  cdn_frontdoor_origin_ids = [azurerm_cdn_frontdoor_origin.RedirectorOrigin.id]
  cdn_frontdoor_rule_set_ids = [azurerm_cdn_frontdoor_rule_set.RedirectorHardeningRuleSet.id]
  enabled = true

  forwarding_protocol = "MatchRequest" # HttpOnly, HttpsOnly or MatchRequest default is MatchRequest
  patterns_to_match = ["/*"]
  supported_protocols = ["Http", "Https"]

  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.RedirectorCustomDomain.id]

  # to disable caching do not define a cache block in configuration file. this is very important.

}