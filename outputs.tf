output "resource_group_name" {
  description = "Name of the spoke resource group"
  value       = azurerm_resource_group.spoke.name
}

output "resource_group_id" {
  description = "ID of the spoke resource group"
  value       = azurerm_resource_group.spoke.id
}

output "spoke_vnet_id" {
  description = "ID of the spoke virtual network"
  value       = module.spoke_vnet.vnet_id
}

output "spoke_vnet_name" {
  description = "Name of the spoke virtual network"
  value       = module.spoke_vnet.vnet_name
}

output "spoke_subnet_ids" {
  description = "Map of subnet names to IDs in spoke VNet"
  value       = module.spoke_vnet.subnet_ids
}

output "workload_subnet_id" {
  description = "ID of the workload subnet"
  value       = module.spoke_vnet.subnet_ids["workload-subnet"]
}

output "private_endpoint_subnet_id" {
  description = "ID of the private endpoint subnet"
  value       = module.spoke_vnet.subnet_ids["private-endpoint-subnet"]
}

output "appgw_subnet_id" {
  description = "ID of the application gateway subnet"
  value       = module.spoke_vnet.subnet_ids["appgw-subnet"]
}

output "hub_route_table_id" {
  description = "ID of the hub route table (centralized)"
  value       = var.hub_route_table_id
}

output "nsg_ids" {
  description = "Map of NSG IDs for all subnets"
  value       = module.spoke_nsgs.nsg_ids
}

output "nsg_names" {
  description = "Map of NSG names for all subnets"
  value       = module.spoke_nsgs.nsg_names
}

output "vnet_peering_spoke_to_hub_id" {
  description = "ID of the VNet peering from spoke to hub"
  value       = azurerm_virtual_network_peering.spoke_to_hub.id
}

output "vnet_peering_hub_to_spoke_id" {
  description = "ID of the VNet peering from hub to spoke"
  value       = azurerm_virtual_network_peering.hub_to_spoke.id
}

# Linux VM Outputs
output "vm_id" {
  description = "ID of the Linux VM"
  value       = azurerm_linux_virtual_machine.vm.id
}

output "vm_name" {
  description = "Name of the Linux VM"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "vm_private_ip" {
  description = "Private IP address of the Linux VM"
  value       = azurerm_network_interface.vm_nic.private_ip_address
}
