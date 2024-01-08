resource "azurerm_virtual_network" "devops-vnet" {
  name                = "devops-network"
  location            = azurerm_resource_group.devops-rg.location
  resource_group_name = azurerm_resource_group.devops-rg.name
  address_space       = ["10.10.0.0/16"]
}  

# Create subnets
resource "azurerm_subnet" "public" {
  name                 = "${var.vnet_name}-public-subnet"
  resource_group_name  = azurerm_resource_group.devops-rg.name
  virtual_network_name = azurerm_virtual_network.devops-vnet.name
  address_prefixes     = [cidrsubnet(var.address_space, 8, 1)]
}

resource "azurerm_subnet" "private" {
  name                 = "${var.vnet_name}-private-subnet"
  resource_group_name  = azurerm_resource_group.devops-rg.name
  virtual_network_name = azurerm_virtual_network.devops-vnet.name
  address_prefixes     = [cidrsubnet(var.address_space, 8, 10)]
}

# Create public IP
resource "azurerm_public_ip" "this" {
  name                = "${var.vnet_name}-Public-IP"
  location                = azurerm_resource_group.devops-rg.location
  resource_group_name     = azurerm_resource_group.devops-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [1]
}

#Nat Gateway
resource "azurerm_nat_gateway" "this" {
  name                    = "${var.vnet_name}-NAT"
  location                = azurerm_resource_group.devops-rg.location
  resource_group_name     = azurerm_resource_group.devops-rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = [1]
}

# Nat - Public IP Association
resource "azurerm_nat_gateway_public_ip_association" "this" {
 nat_gateway_id       = azurerm_nat_gateway.this.id
 public_ip_address_id = azurerm_public_ip.this.id
}

# NAT - Subnets association
resource "azurerm_subnet_nat_gateway_association" "this" {
 subnet_id      = azurerm_subnet.private.id
 nat_gateway_id = azurerm_nat_gateway.this.id
}