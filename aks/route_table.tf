# ---------------------------
# Route Table
# ---------------------------
resource "azurerm_route_table" "aks_route_table" {
  name                          = "aks-route-table"
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name

  route {
    name           = "default-route"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}