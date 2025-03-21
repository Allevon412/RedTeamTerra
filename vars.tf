# Static Vars
#
#----------------------------------
//AWS API Credentials
variable "AWS_REGION" {
  default = ""
  description = "The AWS region that the resources will be configured in"
}

variable "AWS_ACCESS_KEY" {
  default = ""
  description = "The AWS access key to used to configure the AWS resources"
}

variable "AWS_SECRET_KEY" {
  default = ""
  description = "The AWS secret key used to configure the AWS resources"
}
// CloudFlare API Credentials
variable "cloudflare_api_token" {
    description = "The Cloudflare API token to use for managing DNS records"
    default = ""
}
variable "cloudflare_api_key" {
  description = "API Key used to managed all CloudFlare resources"
  default = ""
}
variable "cloudflare_email" {
  description = "The email address associated with the CloudFlare account"
  default = ""
}
//Google Cloud API Configuration
variable "google_project_id" {
  description = "The project id that we will be using to setup our resources"
  default = ""
}
variable "google_region" {
  description = "The region that we will be using to setup our resources"
  default = ""
}
variable "google_credentials" {
  description = "The path to the Google Cloud credentials file"
  default = ""
}

//Azure API Configuration
variable "azure_client_secret" {
  default = ""
}

variable "azure_client_id" {
  default = ""
}

variable "azure_tenant_id" {
  default = ""
}

variable "azure_subscription_id" {
  default = ""
}

//EC2 Configuration Variables
variable "EC2_USER" {
  default = "ubuntu"
}
variable "EC2_ROOT" {
  default = "root"
}
#----------------------------------

# Availability Zone Variable
#
#----------------------------------
variable "AVAILABILITY_ZONE" {
  description = "The AWS availability zone"
  type        = string
  default     = "us-west-2a" # You can set a default value or remove this line to require explicit assignment

  validation {
    condition     = contains(["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"], var.AVAILABILITY_ZONE)
    error_message = "The availability zone must be one of: us-west-2a, us-west-2b, us-west-2c, us-west-2d."
  }
}

# Resource Definition
#
#----------------------------------
resource "random_string" "random1" {
  length           = 16
  special          = true
  override_special = "_+"
}

resource "random_string" "resource_code" {
  length  = 10
  special = false
  upper   = false
}

# Local Values
#
#----------------------------------
locals {
  guac_pass = random_string.random1.result
}
