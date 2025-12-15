output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "app_service_default_hostname" {
  value = azurerm_app_service.app.default_site_hostname
}
