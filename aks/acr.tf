
# ---------------------------
# Container Registry
# ---------------------------
resource "azurerm_container_registry" "acr" {
  name                = "acrtestingeus"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false
}

