data "azurerm_resource_group" "rg" {
  name = "ramesh-testing-eus"
}

data "azurerm_virtual_network" "vnet" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name = "testing-vnet-eus"
}

data "azurerm_key_vault" "keyvault" {
  name                = "kvtestingeus"
  resource_group_name = data.azurerm_resource_group.rg.name
}

