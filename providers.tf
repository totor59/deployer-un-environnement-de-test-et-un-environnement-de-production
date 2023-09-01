terraform {
  required_version = "1.5.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
    random = {
      source  = "hashicorp/random"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}