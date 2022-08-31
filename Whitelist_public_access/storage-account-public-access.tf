#####################################
## Storage Account - Public Access ##
#####################################

## White List Traffic from Public Networks

# Create a white list of IP Addresses
variable "white_list_ip" {
  type = list(string)
  description = "List of white list of IP Addresses"
}

# Create Azure Storage Account Network Rules
resource "azurerm_storage_account_network_rules" "rules" {
  storage_account_id = azurerm_storage_account.storage.id

  default_action = "Deny"
  ip_rules       = var.white_list_ip
  bypass         = ["Metrics", "Logging", "AzureServices"]
}