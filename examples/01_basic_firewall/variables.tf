variable "location" {
  type        = string
  description = "Azure region."
  default     = "westeurope"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
  default     = "fk-rg"
}

variable "firewall_sku_tier" {
  type        = string
  description = "Azure Firewall SKU tier."
  default     = "Standard"
}

variable "workload_vm_size" {
  type        = string
  description = "Azure VM size used for the workload test VM."
  default     = "Standard_B1ms"
}

variable "workload_vm_private_ip" {
  type        = string
  description = "Static private IP address of the workload VM."
  default     = "10.0.2.4"
}
