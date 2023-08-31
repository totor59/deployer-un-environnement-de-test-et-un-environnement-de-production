# Creating Virtual Network
resource "azurerm_virtual_network" "network" {
  name                = "${var.prefix}-network-${var.suffix}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name

  subnet {
    name           = "subnet"
    address_prefix = "10.0.1.0/24"
  }

  tags = {
    environment = "prod"
  }
}

# Creating Network Security Group
resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg-${var.suffix}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name
}

# Network Security Group Rules to allow HTTP traffic
resource "azurerm_network_security_rule" "inbound_http" {
  name                        = "${var.prefix}-inbound-http-${var.suffix}"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

# Network Security Group Rules to allow SSH connections
resource "azurerm_network_security_rule" "allow_ssh_inbound" {
  name                        = "${var.prefix}-allow-ssh-inbound-${var.suffix}"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

# Network Security Group Rules to allow outbound HTTPS traffic
resource "azurerm_network_security_rule" "outbound_https" {
  name                        = "${var.prefix}-outbound-https-${var.suffix}"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}
