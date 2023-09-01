# main.tf

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}


resource "azurerm_resource_group" "main" {
  name     = "emotion-tracking-rg"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "emotion-tracking-cluster"
  location            = azurerm_resource_group.main.location
  dns_prefix          = "emotion-tracking"
  resource_group_name = var.resource_group_name
  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = 1
  }
}

resource "azurerm_postgresql_server" "postgres" {
  name                = "emotion-tracking-db"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "GP_Gen5_2"
  storage_mb          = 5120
  ssl_enforcement_enabled = true
  administrator_login          = "gassim92"
  administrator_login_password = "Gassim0908!@#"
  version = "11"
}

resource "azurerm_container_registry" "my_registry" {
  name                = ""myaksregistry${random_integer}""
  resource_group_name = var.resource_group_name 
  location            = var.location
  admin_enabled       = true
  sku                 = "Basic"
}

resource "kubernetes_namespace" "emotion_tracking" {
  metadata {
    name = "emotion-tracking"
  }
}

resource "kubernetes_secret" "db_secret" {
  metadata {
    name      = "db-secret"
    namespace = kubernetes_namespace.emotion_tracking.metadata[0].name
  }

  data = {
    "username" = "your-db-username"
    "password" = "your-db-password"
  }

  type = "Opaque"
}

resource "kubernetes_deployment" "postgres_deployment" {
  metadata {
    name      = "postgres-deployment"
    namespace = kubernetes_namespace.emotion_tracking.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres-container"
          image = "postgres:11"

          env {
            name  = "POSTGRES_USER"
            value = "your-db-username"
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = "your-db-password"
          }
          env {
            name  = "POSTGRES_DB"
            value = "emotiondb"
          }

          port {
            container_port = 5432
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres_service" {
  metadata {
    name      = "postgres-service"
    namespace = kubernetes_namespace.emotion_tracking.metadata[0].name
  }

  spec {
    selector = {
      app = "postgres"
    }

    port {
      port        = 5432
      target_port = 5432
    }
  }
}

resource "kubernetes_deployment" "app_deployment" {
  metadata {
    name      = "app-deployment"
    namespace = kubernetes_namespace.emotion_tracking.metadata[0].name
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "app"
      }
    }

    template {
      metadata {
        labels = {
          app = "app"
        }
      }

      spec {
        container {
          name  = "app-container"
          image = "your-app-image"

          env {
            name  = "DB_HOST"
            value = "postgres-service"
          }

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app_service" {
  metadata {
    name      = "app-service"
    namespace = kubernetes_namespace.emotion_tracking.metadata[0].name
  }

  spec {
    selector = {
      app = "app"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}

resource "azurerm_log_analytics_workspace" "log_workspace" {
  location            = azurerm_resource_group.main.location
  name                = "emotion-tracking-logs"
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.k8s.name
}

output "cluster_rg" {
  value = azurerm_kubernetes_cluster.k8s.resource_group_name
}

# Création de l'équilibreur de charge
resource "azurerm_lb" "nginx_lb" {
  name                = "nginx-lb"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  frontend_ip_configuration {
    name                 = "public"
    public_ip_address_id = azurerm_public_ip.nginx_public_ip.id
  }
}

resource "azurerm_public_ip" "nginx_public_ip" {
  name                = "nginx-public-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
}

resource "azurerm_lb_backend_address_pool" "nginx_backend_pool" {
  name                = "nginx-backend-pool"
  loadbalancer_id     = azurerm_lb.nginx_lb.id
}

resource "azurerm_lb_rule" "nginx_lb_rule" {
  name                = "nginx-lb-rule"
  loadbalancer_id     = azurerm_lb.nginx_lb.id
  backend_address_pool_ids      = [azurerm_lb_backend_address_pool.nginx_backend_pool.id]
  frontend_ip_configuration_name = "public" 

  protocol = "Tcp"
  frontend_port = 443
  backend_port  = 443
}
