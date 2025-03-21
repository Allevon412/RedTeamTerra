# associate microsoft CDN as a resource provider in your subscription
resource "azurerm_resource_provider_registration" "cdn" {
  name = "Microsoft.Cdn"
}

# first step create a new resource group
resource "azurerm_resource_group" "FrontDoorRedirectorResourceGroup" {
  name = "FrontDoorRedirectorResourceGroup"
  location = "East US"
}

# create a new Front Door CDN profile
resource "azurerm_cdn_frontdoor_profile" "FrontDoorRedirectorProfile" {
  name = "FrontDoorRedirectorProfile"
  resource_group_name = azurerm_resource_group.FrontDoorRedirectorResourceGroup.name
  sku_name = "Standard_AzureFrontDoor" // this is the pricing tier related to the current profile
  tags = {
    environment = "FrontDoorRedirector"
    cost_center = "MSFT STD"
  }

}

