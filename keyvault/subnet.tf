

resource "azurerm_subnet" "private_endpoint_subnet" {
  name                 = "private-endpoint-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.4.0/24"]
  # No delegation for private endpoint subnet
}