terraform {
  backend "azurerm" {
    resource_group_name  = "opsia-rg-001"
    storage_account_name = "opsiabackendstorage001"
    container_name       = "opsiabackendcontainer001"
    key                  = "terraform.tfstate"
  }
}
