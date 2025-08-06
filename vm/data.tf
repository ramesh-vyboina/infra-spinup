data "azurerm_subnet" "aks_subnet" {
  name                 = "aks-sub-eus"
  resource_group_name  = data.azurerm_resource_group.rg.name
 virtual_network_name = data.azurerm_virtual_network.vnet.name
}

data "azurerm_resource_group" "rg" {
  name = "ramesh-testing-eus"
}

data "azurerm_virtual_network" "vnet" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name = "testing-vnet-eus"
}