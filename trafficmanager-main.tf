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

resource "random_id" "server" {
  keepers = {
    azi_id = 1
  }

  byte_length = 8
}

resource "azurerm_resource_group" "tm_rg" {
  name     = "trafficmanagerProfile-RG"
  location = "West Europe"
}

resource "azurerm_traffic_manager_profile" "tm_profile" {
  name                   = random_id.server.hex
  resource_group_name    = azurerm_resource_group.example.name
  traffic_routing_method = "Priority" #For Blue/Green Deployment purpose 

  dns_config {
    relative_name = random_id.server.hex
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
    environment = "Blue-Green-Testing"
  }
}