# General Variables
variable "resource_group_name" {
  description = "Name of the resource group for spoke resources"
  type        = string
}

variable "key_vault_name" {
  description = "Name of the Key Vault for storing secrets"
  type        = string
}

variable "key_vault_resource_group_name" {
  description = "Resource group name where the Key Vault is located"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Spoke VNet Variables
variable "spoke_vnet_name" {
  description = "Name of the spoke virtual network"
  type        = string
}

variable "spoke_address_space" {
  description = "Address space for the spoke virtual network"
  type        = list(string)
}

variable "spoke_subnets" {
  description = "Subnets configuration for spoke VNet"
  type = list(object({
    name              = string
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
    delegations = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    })), [])
  }))
}

# Hub VNet Variables (for peering)
variable "hub_vnet_id" {
  description = "Resource ID of the hub virtual network"
  type        = string
}

variable "hub_route_table_id" {
  description = "Resource ID of the hub route table for centralized routing"
  type        = string
}

variable "hub_vnet_name" {
  description = "Name of the hub virtual network"
  type        = string
}

variable "hub_bastion_subnet_address" {
  description = "Address prefix of the bastion subnet in hub VNet for remote access rules"
  type        = string
}

variable "hub_firewall_private_ip" {
  description = "Private IP address of the hub firewall for DNS resolution"
  type        = string
}

variable "hub_resource_group_name" {
  description = "Resource group name of the hub virtual network"
  type        = string
}

variable "hub_allow_gateway_transit" {
  description = "Allow gateway transit from hub to spoke"
  type        = bool
  default     = true
}

variable "use_remote_gateways" {
  description = "Use remote gateways in hub VNet"
  type        = bool
  default     = false
}

# NSG Rules Variables
variable "workload_nsg_rules" {
  description = "Security rules for workload subnet"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

variable "private_endpoint_nsg_rules" {
  description = "Security rules for private endpoint subnet"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

variable "appgw_nsg_rules" {
  description = "Security rules for application gateway subnet"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

# NSG Rules - Map format for lz-module-nsg
variable "nsg_rules" {
  description = "Network security group rules configuration for all subnets"
  type = map(object({
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_range            = optional(string, "*")
    destination_port_range       = optional(string)
    destination_port_ranges      = optional(list(string))
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(list(string))
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
  }))
  default = {}
}

# Linux VM Variables
variable "vm_name" {
  description = "Name of the Linux virtual machine"
  type        = string
  default     = "vm-app-prod"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "vm_admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "vm_ssh_public_key" {
  description = "SSH public key for VM authentication"
  type        = string
}

variable "vm_ssh_key_secret_name" {
  description = "Name of the Key Vault secret to store the SSH public key"
  type        = string
  default     = "vm-ssh-public-key"
}

variable "vm_os_disk_type" {
  description = "OS disk storage account type"
  type        = string
  default     = "Standard_LRS"
}

variable "vm_os_disk_size" {
  description = "OS disk size in GB"
  type        = number
  default     = 30
}

variable "vm_image_publisher" {
  description = "VM image publisher"
  type        = string
  default     = "Canonical"
}

variable "vm_image_offer" {
  description = "VM image offer"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "vm_image_sku" {
  description = "VM image SKU"
  type        = string
  default     = "22_04-lts-gen2"
}

variable "vm_image_version" {
  description = "VM image version"
  type        = string
  default     = "latest"
}

