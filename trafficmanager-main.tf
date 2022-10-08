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

resource "azurerm_resource_group" "tm_rg" {
  name     = "tm-RG"
  location = "West Europe"
}

resource "azurerm_resource_group" "prod_rg" {
  name     = "prod-RG"
  location = "West Europe"
}

resource "azurerm_resource_group" "secondary_rg" {
  name     = "secondary-RG"
  location = "West Europe"
}

# PIP for Primary End point
resource "azurerm_public_ip" "prod_pip" {
  name                = "production_end_pip"
  location            = azurerm_resource_group.prod_rg.location
  resource_group_name = azurerm_resource_group.prod_rg.name
  allocation_method   = "Static"
  domain_name_label   = "production_end_pip"
}

#PIP for failover End point
resource "azurerm_public_ip" "secondary_pip" {
  name                = "failover_end_pip"
  location            = azurerm_resource_group.secondary_rg.location
  resource_group_name = azurerm_resource_group.secondary_rg.name
  allocation_method   = "Static"
  domain_name_label   = "failover_end_pip"
}


resource "azurerm_traffic_manager_profile" "tm_profile" {
  name                   = "tm_profile"
  resource_group_name    = azurerm_resource_group.rg.name
  traffic_routing_method = "Priority" #For B/G it Priority and for canary should be weighted

  dns_config {
    relative_name = "tm-profile"
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

resource "azurerm_traffic_manager_azure_endpoint" "prod_ep" {
  name               = "production-endpoint"
  profile_id         = azurerm_traffic_manager_profile.tm_profile.id
  priority             = 1
  target_resource_id = azurerm_public_ip.prod_pip.id
}

resource "azurerm_traffic_manager_azure_endpoint" "secondary_ep" {
  name               = "example-endpoint"
  profile_id         = azurerm_traffic_manager_profile.tm_profile.id
  priority             = 1
  target_resource_id = azurerm_public_ip.secondary_pip.id
}