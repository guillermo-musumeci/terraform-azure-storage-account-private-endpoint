############################
## Storage Account - Main ##
############################

locals {
  sta_name = "${lower(replace(var.company," ","-"))}${var.environment}${var.shortlocation}sta"
}

# Create Private DNS Zone
resource "azurerm_private_dns_zone" "dns-zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.network-rg.name
}

# Create Private DNS Zone Network Link
resource "azurerm_private_dns_zone_virtual_network_link" "network_link" {
  name                  = "vnet_link"
  resource_group_name = azurerm_resource_group.network-rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns-zone.name
  virtual_network_id    = azurerm_virtual_network.network-vnet.id
}

# Create Storage Account
resource "azurerm_storage_account" "storage" {
  name                = local.sta_name
  resource_group_name = azurerm_resource_group.network-rg.name
  location            = azurerm_resource_group.network-rg.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create Private Endpint
resource "azurerm_private_endpoint" "endpoint" {
  name                = "${local.sta_name}-pe"
  resource_group_name = azurerm_resource_group.network-rg.name
  location            = azurerm_resource_group.network-rg.location
  subnet_id           = azurerm_subnet.endpoint-subnet.id

  private_service_connection {
    name                           = "${local.sta_name}-psc"
    private_connection_resource_id = azurerm_storage_account.storage.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

# Create DNS A Record
resource "azurerm_private_dns_a_record" "dns_a" {
  name                = local.sta_name
  zone_name           = azurerm_private_dns_zone.dns-zone.name
  resource_group_name = azurerm_resource_group.network-rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.endpoint.private_service_connection.0.private_ip_address]
}

