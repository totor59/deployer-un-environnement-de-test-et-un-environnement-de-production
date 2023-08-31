# main.tf

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "emotion-tracking-rg"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "emotion-tracking-cluster"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "emotion-tracking"

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
  administrator_login          = "your-admin-username"
  administrator_login_password = "your-admin-password"
  version = "11"
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
