data "azurerm_resource_group" "example" {
  name = "${var.prefix}-rg-${var.suffix}"
}