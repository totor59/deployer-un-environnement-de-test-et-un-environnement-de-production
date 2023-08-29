resource "azurerm_container_group" "db" {
  name                = "opsia-dev"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  ip_address_type     = "Public"
  dns_name_label      = "${var.prefix}-dev"
  os_type             = "Linux"
  image_registry_credential {
    username = "opsia"
    password = "aQnXJQadhBY/slxIK9p0lGlX6ZuI4rMtBdXqQlBLky+ACRCCuTcm"
    server   = "opsia.azurecr.io"
  }
  container {
    name   = "postgres-dev"
    image  = "opsia.azurecr.io/postgres:v1"
    cpu    = "0.5"
    memory = "1.5"
    # ports {
    #   port     = 8080
    #   protocol = "TCP"
    # }
    volume {
      name       = "postgres-data"
      mount_path = "/var/lib/postgresql/data"
      empty_dir  = true
    }
    environment_variables = {
      POSTGRES_DB       = "emotion_db"
      POSTGRES_USER     = "main_user"
      POSTGRES_PASSWORD = "pwd"
    }
  }

  container {
    name   = "elasticsearch-dev"
    image  = "opsia.azurecr.io/elasticsearch:v1"
    cpu    = "0.5"
    memory = "1.5"
    ports {
      port     = 9200
      protocol = "TCP"
    }
    volume {
      name       = "elastic-data"
      mount_path = "/usr/share/elasticsearch/data/nodes"
      empty_dir  = true
    }
  }

  container {
    name   = "adminer-dev"
    image  = "opsia.azurecr.io/adminer:v1"
    cpu    = "0.5"
    memory = "1.5"
    ports {
      port     = 81
      protocol = "TCP"
    }
  }

  container {
    name   = "emotiontracking-dev"
    image  = "opsia.azurecr.io/emotion-tracking:v1"
    cpu    = "0.5"
    memory = "1.5"
    ports {
      port     = 8000
      protocol = "TCP"
    }
    volume {
      name       = "emotion-data"
      mount_path = "/app"
      git_repo {
        url = "https://github.com/votre-utilisateur/votre-repo.git"
        directory  = "/path/to/git/repo"
        revision   = "main" # La branche, le tag ou le commit à utiliser
      }
    }
    commands = [
      "bash",
      "-c",
      "python manage.py makemigrations && python manage.py migrate && python ./src/postgre_patient_import.py && python ./src/elastic_mapping_import.py && python manage.py runserver 0.0.0.0:8000"
    ]
    environment_variables = {
      POSTGRES_DB       = "emotion_db"
      POSTGRES_USER     = "main_user"
      POSTGRES_PASSWORD = "pwd"
    }
  }

  tags = {
    environment = "dev"
  }
}
