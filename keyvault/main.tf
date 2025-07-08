resource "azurerm_key_vault" "kv" {
  name                        = "kvtestingeus"
  location                    = data.azurerm_resource_group.rg.location
  resource_group_name         = data.azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  enable_rbac_authorization   = true
  purge_protection_enabled    = true
  soft_delete_retention_days  = 7
}



#resource "azurerm_key_vault_key" "encryption_key" {
#  name         = "aks-key"
#  key_vault_id = azurerm_key_vault.kv.id
#  key_type     = "RSA"
#  key_size     = 2048
#  key_opts     = ["encrypt", "decrypt", "wrapKey", "unwrapKey"]
#}



