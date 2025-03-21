variable "redirector" {
    description = "The domain name that points to our redirector server"
    type = string
}

variable "region" {
    default = "us-east-1"
    description = "The default AWS region to use for deployment of certificates"
}

variable "domain_name_for_cdn" {
    description = "The domain name that our CDN should use"
    type = string
}

variable "alternate_domain_name" {
    description = "An alternate domain name that our CDN should use instead of the default generated one"
    type = string
}