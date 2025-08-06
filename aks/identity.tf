# Removed unused azurerm_user_assigned_identity "aks_identity" resource as it was not referenced elsewhere.
# Grant AKS identity permission to pull images from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}

# ---------------------------
# Grant Key Vault access to AKS identity
# ---------------------------
resource "azurerm_key_vault_access_policy" "aks_kv_access" {
  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.aks_identity.principal_id

  secret_permissions = ["Get", "List"]
  key_permissions    = ["Get"]
}