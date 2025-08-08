variable "resource_group_name" {
  description = "资源组名称"
  default     = "aks-rg"
}

variable "location" {
  description = "Azure区域"
  default     = "East US"
}

variable "cluster_name" {
  description = "AKS集群名称"
  default     = "myAKSCluster"
}

variable "dns_prefix" {
  description = "AKS DNS前缀"
  default     = "myakscluster"
}

variable "node_count" {
  description = "默认节点池中的节点数量"
  default     = 2
}

variable "vm_size" {
  description = "节点VM大小"
  default     = "Standard_D2_v2"
}

variable "admin_username" {
  description = "管理员用户名"
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH公钥"
  default     = "~/.ssh/id_rsa.pub"
}