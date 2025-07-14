resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-cluster"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = "aksdns"

  default_node_pool {
    name           = "defaultpool"
    node_count     = 1
    vm_size        = "Standard_B2s" # Basic VM size
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_kv_identity.id]
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    dns_service_ip = "10.2.0.10"
    service_cidr   = "10.2.0.0/24"
    outbound_type  = "loadBalancer"
  }

  private_cluster_enabled = true

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = false
    tenant_id          = data.azurerm_client_config.current.tenant_id
  }
}

resource "azurerm_user_assigned_identity" "aks_kv_identity" {
  name                = "aks-kv-identity"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
}

resource "azurerm_container_registry" "acr" {
  name                = "acrtestingeus"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Premium"
  admin_enabled       = false
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id         = azurerm_user_assigned_identity.aks_kv_identity.principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}

resource "azurerm_key_vault_access_policy" "aks" {
  key_vault_id = data.azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.aks_kv_identity.principal_id

  key_permissions    = ["Get", "List"]
  secret_permissions = ["Get", "List"]
}

# Key Vault integration for AKS
#resource "azurerm_key_vault_access_policy" "aks_secrets_provider" {
#  key_vault_id = data.azurerm_key_vault.keyvault.id
#  tenant_id    = data.azurerm_client_config.current.tenant_id
#  object_id    = azurerm_user_assigned_identity.aks_kv_identity.principal_id
#
#  secret_permissions = ["Get", "List"]
#  key_permissions    = ["Get", "List"]
#}

# Data sources for current client and vnet

data "azurerm_client_config" "current" {}
# data.azurerm_virtual_network.vnet and data.azurerm_resource_group.rg assumed to be defined elsewhere


