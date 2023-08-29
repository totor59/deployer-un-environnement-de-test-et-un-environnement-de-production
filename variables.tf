variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
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
  default     = "northeurope"
}
