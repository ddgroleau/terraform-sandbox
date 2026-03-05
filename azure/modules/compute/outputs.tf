output "kube_client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
  sensitive = true
}

output "kube_cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate
  sensitive = true
}

output "kube_client_key" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].client_key
  sensitive = true
}

output "kube_api_endpoint" {
  value = azurerm_kubernetes_cluster.aks.kube_config[0].host
}
output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}


output "admin_kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  sensitive = true
}

output "cluster_id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "fqdn" {
  value = azurerm_kubernetes_cluster.aks.fqdn
}

