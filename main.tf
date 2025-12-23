# Resource Group for Spoke Application
resource "azurerm_resource_group" "spoke" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Key Vault Data Source for SSH Key Storage
data "azurerm_key_vault" "shared" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group_name
}

# Spoke Virtual Network using LZ Module
module "spoke_vnet" {
  source = "git::https://github.com/sdas1990/az-lz-module.git//modules/lz-module-vnet?ref=v1.1.2"

  name                = var.spoke_vnet_name
  resource_group_name = azurerm_resource_group.spoke.name
  location            = azurerm_resource_group.spoke.location
  address_space       = var.spoke_address_space
  dns_servers         = [var.hub_firewall_private_ip]
  subnets             = var.spoke_subnets
  tags                = var.tags
}

# Network Security Groups for Subnets
module "spoke_nsgs" {
  source = "git::https://github.com/sdas1990/az-lz-module.git//modules/lz-module-nsg?ref=v1.1.2"

  resource_group_name = azurerm_resource_group.spoke.name
  location            = azurerm_resource_group.spoke.location
  subnet_ids          = module.spoke_vnet.subnet_ids
  nsg_rules           = var.nsg_rules
  tags                = var.tags
}

# Associate Subnets with Hub Route Table
resource "azurerm_subnet_route_table_association" "workload" {
  subnet_id      = module.spoke_vnet.subnet_ids["workload-subnet"]
  route_table_id = var.hub_route_table_id
}

resource "azurerm_subnet_route_table_association" "private_endpoint" {
  subnet_id      = module.spoke_vnet.subnet_ids["private-endpoint-subnet"]
  route_table_id = var.hub_route_table_id
}

# VNet Peering: Spoke to Hub
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "peer-${var.spoke_vnet_name}-to-hub"
  resource_group_name          = azurerm_resource_group.spoke.name
  virtual_network_name         = module.spoke_vnet.vnet_name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = var.use_remote_gateways
}

# VNet Peering: Hub to Spoke (requires permissions in hub subscription)
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "peer-hub-to-${var.spoke_vnet_name}"
  resource_group_name          = var.hub_resource_group_name
  virtual_network_name         = var.hub_vnet_name
  remote_virtual_network_id    = module.spoke_vnet.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = var.hub_allow_gateway_transit
  use_remote_gateways          = false
}

# Store SSH Public Key in Key Vault
# Note: Requires Key Vault Secrets Officer role assignment
# resource "azurerm_key_vault_secret" "vm_ssh_public_key" {
#   name         = var.vm_ssh_key_secret_name
#   value        = var.vm_ssh_public_key
#   key_vault_id = data.azurerm_key_vault.shared.id
#
#   tags = var.tags
# }

# Linux VM in Workload Subnet
resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.spoke_vnet.subnet_ids["workload-subnet"]
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.vm_name
  resource_group_name             = azurerm_resource_group.spoke.name
  location                        = azurerm_resource_group.spoke.location
  size                            = var.vm_size
  admin_username                  = var.vm_admin_username
  disable_password_authentication = true
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id
  ]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = var.vm_ssh_public_key
  }

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.vm_os_disk_type
    disk_size_gb         = var.vm_os_disk_size
  }

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }

  tags = var.tags
}
