module "aws_front_door_redirector" {
  source = "./AWSCloudFrontRedirector"
  redirector = "" # this is the domain name of your redirector
  domain_name_for_cdn = "" # this is the domain name of your relay that will point to your redirector from AWS
  alternate_domain_name = "" # this is the domain name of your relay that will point to your redirector from AWS
  providers = {
    aws = aws
    cloudflare = cloudflare
  }
}

module "Azure_front_door_redirector" {
  source = "./AzureFrontDoorRedirector"
  redirector_domain = "" # this is the domain name of your redirector
  custom_domain = "" # this is the domain name of the relay that will point to your redirector from Azure CDN
    providers = {
        azurerm = azurerm
        cloudflare = cloudflare
    }
}

module "CloudFlare" {
  source = "./CloudFlareDNS"
  redirector_public_ip = aws_eip.redirector-server-eip.public_ip
  domain_name = "" # this is the domain name you want your redirector to be accessible from
  providers = {
    cloudflare = cloudflare
  }
}

module "google_cloud_redirector" {
  source = "./GCPRedirector"
  cloudfront_domain = "" # this is the domain name of your relay that will point to your redirector from GCP
  redirector_domain = "" # this is the domain name of your redirector
  project_id = ""
    providers = {
        google = google
        cloudflare = cloudflare
    }
}

module "aws_lambda_relay" {
  source = "./lambda_relay"
  subnet_id = aws_subnet.prod-subnet-public-1.id
  security_group_id = aws_security_group.subnet-sg-redir.id
    providers = {
        aws = aws
    }
}





