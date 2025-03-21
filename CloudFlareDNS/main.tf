data "cloudflare_zone" "zone_data" {
  filter = {
    name = var.domain_name
  }
}


resource "cloudflare_dns_record" "dns_record" {
  zone_id = data.cloudflare_zone.zone_data.zone_id
  name = var.domain_name
  content = var.redirector_public_ip
  type = "A"
  ttl = 60
  proxied = false
}

