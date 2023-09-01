# Variables for Azure
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "ec907711-acd7-4191-9983-9577afbe3ce1"
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  default     = "a2e466aa-4f86-4545-b5b8-97da7c8febf3"
}

variable "client_id" {
  description = "client_id for service principal"
  type        = string
  default     = "01775374-4166-4be1-ba12-5cc3961c984b"
}

variable "client_secret" {
  description = "client_secret for service principal"
  type        = string
  default     = "yzb8Q~gPKCmWPMAL.QcbDwI7kEN7tshoVqxzVc6I"
}

# Variables for Azure Resource Group and Naming
variable "resource_group_name" {
  description = "Azure existing resource group name"
  type        = string
  default     = "opsia-rg-001"
}

variable "prefix" {
  description = "Prefix for resource names."
  type        = string
  default     = "opsia"
}

variable "suffix" {
  description = "Suffix for resource names."
  type        = string
  default     = "001"
}

variable "location" {
  description = "Location for Azure resources."
  type        = string
  default     = "North Europe"
}

# Variables for AKS (Azure Kubernetes Service)
variable "node_count" {
  description = "Number of nodes in the AKS cluster."
  type        = number
  default     = 2
}

variable "admin_username" {
  description = "Admin username for VMs."
  type        = string
  default     = "adminuser"
}

variable "vm_size" {
  description = "Size of the VMs in the agent pool."
  type        = string
  default     = "Standard_DS2_v2"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster."
  type        = string
  default     = "1.21.7"
}

variable "azurerm_kubernetes_cluster" {
  description = "Kubernetes cluster name"
  type        = string
  default     = "opsai-akc"
}

# Variables for Database and Application
variable "db_admin_username" {
  description = "Admin username for the database."
  type        = string
  default     = "gassim"
}

variable "db_admin_password" {
  description = "Admin password for the database."
  type        = string
  default     = "Gassim92!@"
}

variable "db_username" {
  description = "Username for the database."
  type        = string
  default     = "gassim"
}

variable "db_password" {
  description = "Password for the database."
  type        = string
  default     = "Gassim92!@"
}

variable "app_image" {
  description = "Docker image for the application."
  type        = string
  default     = "emotion-tracking"
}
