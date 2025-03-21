terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 6.25.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = ">= 5.1.0"
    }
  }
}