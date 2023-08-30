#main-prod.tf

# Cluster Kubernetes // opsia-rg-001 

# Creating AKS Cluster
resource "azurerm_aks_cluster" "aks_cluster" {
  name                = "opsai-001"
  location            = "default"
  resource_group_name = "default"
  dns_prefix          = "myakscluster"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = var.node_count
  }

  service_principal {
    client_id     = "01775374-4166-4be1-ba12-5cc3961c984b"
    client_secret = "yzb8Q~gPKCmWPMAL.QcbDwI7kEN7tshoVqxzVc6I"
  }
}

# Creating Kubernetes Secrets
resource "kubernetes_secret" "my_secret" {
  metadata {
    name      = "my-secret"
    namespace = "default"  # Replace with your desired namespace
  }

  data = {
    "username" = "my-username"
    "password" = "my-password"
  }

  type = "Opaque"
}

# Creating Kubernetes Deployment
resource "kubernetes_deployment" "example" {
  metadata {
    name      = "my-deployment"
    namespace = "default"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "my-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-app"
        }
      }

      spec {
        container {
          name  = "my-container"
          image = "my-image:latest"
          
          # Additional container configuration
          ports {
            container_port = 80
          }
          
          env {
            name  = "MY_ENV_VAR"
            value = "my-value"
          }
        }
      }
    }
  }
}

# Creating Services
resource "kubernetes_service" "web_service" {
  metadata {
    name = "web-service"
  }

  spec {
    selector = {
      app = "web-app"
    }

    port {
      port        = 80
      target_port = 8080
    }
  }
}

# Creating container registory 
resource "azurerm_container_registry" "my_registry" {
  name                = "myregistry"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
  sku                 = "Standard"

  admin_enabled = false
  tags = {
    environment = "prod"
  }
}

# Creating Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log_workspace" {
  location            = var.location
  name                = "${var.prefix}-${var.suffix}-logs"  # Replace with your desired name
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30  
}
