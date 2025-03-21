
# following attributes are exported ID, Expiration Date, & Validation Token (TXT record) for DNS verification
resource "azurerm_cdn_frontdoor_custom_domain" "RedirectorCustomDomain" {
  name = "RedirectorCustomDomain"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.FrontDoorRedirectorProfile.id
  # dns_zone_id =  this parameter is to be used when you are using azure to manage your domains. Otherwise you'll need to manually create the verification record and the CNAME record in your DNS provider.
  host_name = var.custom_domain
  tls {
    certificate_type = "ManagedCertificate" # ManagedCertificate or CustomerCertificate default is ManagedCertificate
    minimum_tls_version = "TLS12" # TLS12
  }
}

data "cloudflare_zone" "bankofbreadman_org" {
  filter = {
    name = var.custom_domain
  }
}

resource "cloudflare_dns_record" "bankofbreadman_org_txt_record_validation" {

  zone_id = data.cloudflare_zone.bankofbreadman_org.zone_id
  name = join(".", ["_dnsauth", var.custom_domain])
  content = azurerm_cdn_frontdoor_custom_domain.RedirectorCustomDomain.validation_token
  type = "TXT"
  ttl = 60
  proxied = false

}

resource "azurerm_cdn_frontdoor_custom_domain_association" "RedirectorCustomDomainAssociation" {
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.RedirectorCustomDomain.id
  cdn_frontdoor_route_ids = [azurerm_cdn_frontdoor_route.RedirectorRoute.id]
}

resource "cloudflare_dns_record" "bankofbreadman_org_cname_record" {

  zone_id = data.cloudflare_zone.bankofbreadman_org.zone_id
  name = var.custom_domain
  content = azurerm_cdn_frontdoor_endpoint.RedirectorEndpoint.host_name
  type = "CNAME"
  ttl = 60
  proxied = false
}