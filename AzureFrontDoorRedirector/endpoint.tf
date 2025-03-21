resource "azurerm_cdn_frontdoor_endpoint" "RedirectorEndpoint" {
  name               = "redirectorEndpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.FrontDoorRedirectorProfile.id
}

