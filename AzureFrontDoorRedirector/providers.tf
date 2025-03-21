terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.22.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = ">= 5.1.0"
    }
  }
}