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

variable "prefix" {
  description = "Préfixe de nom pour les ressources."
  type        = string
  default     = "opsia"
}

variable "suffix" {
  description = "Suffixe de nom pour les ressources."
  type        = string
  default     = "001"
}

variable "location" {
  description = "Localisation des ressources."
  type        = string
  default     = "North Europe"
}

/////////////////////////////////////////////
#variables.tf

variable "node_count" {
  description = "Number of nodes in the AKS cluster."
  type        = number
  default     = 3
}

variable "admin_username" {
  description = "Admin username for VMs."
  type        = string
  default     = "adminuser"
}

variable "ssh_pub_key" {
  description = "SSH public key for VM access."
  type        = string
  default     = ""
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

variable "author" {
  description = "Maintainer or author of the configuration."
  type        = string
  default     = "Your Name"
}

variable "poc-name" {
  description = "Name of the Proof of Concept."
  type        = string
  default     = "poc"
}

variable "client_secret" {
  description = "Client secret for the Azure AD application."
  type        = string
  default     = "your_client_secret"
}
