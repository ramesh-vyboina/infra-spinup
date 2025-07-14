resource "azurerm_subnet" "acr_private_endpoint_subnet" {
  name                 = "acr-pe-sub-eus"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.5.0/24"]
}

resource "azurerm_private_endpoint" "acr_pe" {
  name                = "acr-pe-eus"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.acr_private_endpoint_subnet.id

  private_service_connection {
    name                           = "acr-pe-conn"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }
}

resource "azurerm_private_dns_zone" "acr_dns" {
  name                = "privatelink.azurecr.io"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr_dns_link" {
  name                  = "acr-dns-link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.acr_dns.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_a_record" "acr_dns_record" {
  name                = azurerm_container_registry.acr.name
  zone_name           = azurerm_private_dns_zone.acr_dns.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.acr_pe.private_service_connection[0].private_ip_address]
}

resource "azurerm_role_assignment" "aks_acr_rbac" {
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}
