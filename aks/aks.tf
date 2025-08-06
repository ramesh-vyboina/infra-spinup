resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "aks-identity"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}


# ---------------------------
# AKS Cluster
# ---------------------------
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-cluster"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = "aksdns"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_B2s"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    dns_service_ip     = "10.2.0.10"
    service_cidr       = "10.2.0.0/24"
    #docker_bridge_cidr = "172.17.0.1/16"
    outbound_type      = "loadBalancer"
  }

  private_cluster_enabled = true

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }
 
  azure_active_directory_role_based_access_control {
   # managed                = true
    tenant_id               = data.azurerm_client_config.current.tenant_id
    #admin_group_object_ids = ["<AAD-GROUP-OBJECT-ID>"]
  }

  role_based_access_control_enabled = true
}




# Data sources for current client and vnet

data "azurerm_client_config" "current" {}
# data.azurerm_virtual_network.vnet and data.azurerm_resource_group.rg assumed to be defined elsewhere


