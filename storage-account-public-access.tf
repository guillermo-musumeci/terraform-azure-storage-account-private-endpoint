#####################################
## Storage Account - Public Access ##
#####################################

## Allow Traffic from ALL Public Networks

# Create Azure Storage Account Network Rules
resource "azurerm_storage_account_network_rules" "rules" {
  storage_account_id = azurerm_storage_account.storage.id
  
  default_action = "Allow"
  bypass         = ["Metrics", "Logging", "AzureServices"]
}