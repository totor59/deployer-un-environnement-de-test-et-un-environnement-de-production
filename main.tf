data "azurerm_resource_group" "main" {
  name = "${var.prefix}-rg-${var.suffix}"
}

data "azurerm_container_registry" "main" {
  name                = var.prefix
  resource_group_name = data.azurerm_resource_group.main.name
}
