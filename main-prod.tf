# Création de cluster Kubernetes

resource "azurerm_aks_cluster" "aks_cluster" {
  name                = "opsai-001"
  location            = "default"
  resource_group_name = "default"
dns_prefix          = random_pet.azurerm_kubernetes_cluster_dns_prefix.id  

  identity {
    type = "SystemAssigned"
  }

default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = var.node_count
  }
  linux_profile {
    admin_username = var.username

    ssh_key {
      key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
    }
  }

  network_profile {
    network_plugin    = "kubenet001"
    load_balancer_sku = "standard"
  }
}