####################
## Network - Main ##
####################

# Create a resource group for network
resource "azurerm_resource_group" "network-rg" {
  name     = "${lower(replace(var.company," ","-"))}-${var.environment}-${var.shortlocation}-rg"
  location = var.location
  tags = {
    application = var.app_name
    environment = var.environment
  }
}

# Create the network VNET
resource "azurerm_virtual_network" "network-vnet" {
  name                = "${lower(replace(var.company," ","-"))}-${var.environment}-${var.shortlocation}-vnet"
  address_space       = [var.network-vnet-cidr]
  resource_group_name = azurerm_resource_group.network-rg.name
  location            = azurerm_resource_group.network-rg.location
  tags = {
    application = var.app_name
    environment = var.environment
  }
}

# Create a Endpoint Subnet
resource "azurerm_subnet" "endpoint-subnet" {
  name                 = "${lower(replace(var.company," ","-"))}-${var.environment}-${var.shortlocation}-endpoint-subnet"
  address_prefixes     = [var.network-endpoint-subnet-cidr]
  virtual_network_name = azurerm_virtual_network.network-vnet.name
  resource_group_name  = azurerm_resource_group.network-rg.name

  private_endpoint_network_policies_enabled = true
}

