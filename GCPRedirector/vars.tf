variable "project_id" {
  description = "The project id that we will be using to setup our resources"
  type = string
}

variable "redirector_domain" {
    description = "The domain name of the origin redirector server"
    type = string
}

variable "cloudfront_domain" {
    description = "The domain name of the redirector server"
    type = string
}
