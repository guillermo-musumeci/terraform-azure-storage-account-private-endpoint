# Deploying a Azure Storage Account using Terraform

Code creates:

- Resource Group
- VNET
- Endpoint Subnet
- Private DNS zone
- Virtual Network Link
- Storage Account
- Storage Account Private Endpoint
- Storage Account DNS A Record

## Public Access

To configure Public Access just copy the file **storage-account-public-access.tf** from the appropiate folder.

- Allow traffic from public networks --> **Allow_public_access** folder
- Use a white list to filter public access --> **Whitelist_public_access** folder
- Disable traffic from public networks --> **Deny_public_access** folder
