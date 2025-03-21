# AWS Provider Configuration
#
#----------------------------------

//GCPRedirector/providers.tf
# information on authentication and provider usage https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference
# information on GCP CDN under the hood. https://medium.com/cognite/configuring-google-cloud-cdn-with-terraform-ab65bb0456a9
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
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.89.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.22.0"
    }
  }
}


provider "google" {
  credentials = file(var.google_credentials)
  project = var.google_project_id
  region = var.google_region
}
 // AzureFrontDoorRedirector/providers.tf

provider "azurerm" {
  # Configuration options
  features {}
  client_id = var.azure_client_id
  client_secret = var.azure_client_secret
  tenant_id = var.azure_tenant_id
  subscription_id = var.azure_subscription_id
}

// AWSCloudFrontRedirector/providers.tf
provider "aws" {
  region = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

provider "cloudflare" {
  #api_token = var.cloudflare_api_token
  api_key = var.cloudflare_api_key
  email = var.cloudflare_email
}