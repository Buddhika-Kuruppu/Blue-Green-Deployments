#=================#
# provider details#
#=================#
terraform { 
    required_providers { 
        azurerm = { 
            source = "hashicorp/azurerm" 
            version = "1.3.1" 
            } 
        } 
    } 
            
    provider "azurerm" { 
        features {} 
        }

#==============================#
# Traffic Manager provisioning #
#==============================#

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  domain_name_label   = "example-public-ip"
}


resource "azurerm_traffic_manager_profile" "example" {
  name                   = "example-profile"
  resource_group_name    = azurerm_resource_group.example.name
  traffic_routing_method = "Weighted"

  dns_config {
    relative_name = "example-profile"
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_traffic_manager_azure_endpoint" "example" {
  name               = "example-endpoint"
  profile_id         = azurerm_traffic_manager_profile.example.id
  weight             = 100
  target_resource_id = azurerm_public_ip.example.id
}