resource "azurerm_private_dns_zone" "aks_dns" {
  name                = "privatelink.${azurerm_kubernetes_cluster.aks.location}.azmk8s.io"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks_dns_link" {
  name                  = "aks-dns-link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.aks_dns.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
}


resource "azurerm_private_dns_a_record" "aks_dns_record" {
  name                = azurerm_kubernetes_cluster.aks.name
  zone_name           = azurerm_private_dns_zone.aks_dns.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.acr_pe.private_service_connection[0].private_ip_address]
}