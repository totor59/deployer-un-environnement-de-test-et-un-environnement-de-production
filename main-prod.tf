# Création de cluster Kubernetes

resource "azurerm_aks_cluster" "aks_cluster" {
  name                = "my-aks-cluster"
  location            = "North Europe"
  resource_group_name = "opsia-rg-001"
  dns_prefix          = "myaks"
  
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}
