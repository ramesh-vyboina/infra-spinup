resource "azurerm_route_table" "aks_route_table" {
  name                = "aks-route-table"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

}

resource "azurerm_subnet_route_table_association" "aks_subnet_assoc" {
  subnet_id      = azurerm_subnet.aks_subnet.id
  route_table_id = azurerm_route_table.aks_route_table.id
}
