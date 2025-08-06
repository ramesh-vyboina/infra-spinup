


data "azurerm_resource_group" "rg" {
  name = "ramesh-testing-eus"
}

data "azurerm_virtual_network" "vnet" {
  name                = "testing-vnet-eus"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_key_vault" "kv" {
  name                = "kvtestingeus"
  resource_group_name = data.azurerm_resource_group.rg.name
}