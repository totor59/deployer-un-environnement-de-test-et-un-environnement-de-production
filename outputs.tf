# outputs.tf

output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.k8s.name
}

output "container_registry_url" {
  description = "URL of the container registry"
  value       = azurerm_container_registry.my_registry.login_server
}

output "log_workspace_id" {
  description = "ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.log_workspace.id
}

output "kubernetes_config" {
  description = "Kubernetes configuration"
  value       = azurerm_kubernetes_cluster.k8s.kube_config_raw
  sensitive   = true
}

output "network_security_group_id" {
  description = "ID of the Network Security Group"
  value       = azurerm_network_security_group.main.id
}

output "virtual_network_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.network.id
}

output "client_id" {
  description = "Client ID of the Service Principal"
  value       = var.client_id
  sensitive   = true
}

output "client_secret" {
  description = "Client Secret of the Service Principal"
  value       = var.client_secret
  sensitive   = true
}

# Output pour l'adresse IP publique du Load Balancer
output "nginx_lb_public_ip" {
  value = azurerm_public_ip.nginx_public_ip.ip_address
}
