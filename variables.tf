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
