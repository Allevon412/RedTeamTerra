output "TXTRecord" {
  value = azurerm_cdn_frontdoor_custom_domain.RedirectorCustomDomain.validation_token
}