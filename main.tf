# 创建资源组
resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location
}

# 创建虚拟网络
resource "azurerm_virtual_network" "aks_vnet" {
  name                = "aks-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
}

# 创建子网
resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 创建AKS集群
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.cluster_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name           = "default"
    node_count     = var.node_count
    vm_size        = var.vm_size
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

    network_profile {
    network_plugin     = "azure"                   # 使用 Azure CNI
    network_policy     = "azure"                  # 可选：启用网络策略（calico 或 azure）
    service_cidr       = "10.1.0.0/16"             # 必须不与子网冲突
    dns_service_ip     = "10.1.0.10"               # 必须在 service_cidr 范围内
    docker_bridge_cidr = "172.17.0.1/16"           # Docker 桥接网络（默认值）
    outbound_type      = "loadBalancer"            # 或 "userDefinedRouting"（如果使用自定义路由）
  }

  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

}

# # 输出AKS配置
# output "client_certificate" {
#   value     = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate
#   sensitive = true
# }

# output "kube_config" {
#   value     = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
#   sensitive = true
# }

# output "host" {
#   value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
# }