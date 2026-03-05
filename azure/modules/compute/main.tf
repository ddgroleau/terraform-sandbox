# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.environment}-aks-cluster"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.environment}-aks"

  # Deploy into private subnets for security
  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    service_cidr      = "10.1.0.0/16"
    dns_service_ip    = "10.1.0.10"
    pod_cidr          = "172.17.0.1/16"
    load_balancer_sku = "standard"
  }

  # Node pool w/ multi AZ private subnets and auto-scaling
  default_node_pool {
    name                 = "default"
    vm_size              = "Standard_D2_v2"
    auto_scaling_enabled = true
    min_count            = 2
    max_count            = 5
    vnet_subnet_id       = var.private_subnet_ids[0]
    zones                = ["1", "2"]
  }

  # Managed Identity
  identity {
    type = "SystemAssigned"
  }

  ingress_application_gateway {
    gateway_id = var.app_gateway_id
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# AKS cluster identity needs contributor access on App Gateway
resource "azurerm_role_assignment" "aks_agic_appgw" {
  scope                = var.app_gateway_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

# AKS cluster identity needs Network Contributor on VNet
resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = var.vnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}


