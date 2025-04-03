
# Creating azure resource group
resource "azurerm_resource_group" "tflearning" {
  name = "tf-rg-1"
  location = "East US"
}

# creating azure storage account
resource "azurerm_storage_account" "tfstorageaccount" {
  name = "tfstorageaccount1980"
  location = azurerm_resource_group.tflearning.location
  resource_group_name = azurerm_resource_group.tflearning.name
  account_tier = "Standard"
  account_replication_type = "LRS"
  
}

# Creating azure storage container
resource "azurerm_storage_container" "tfstoragecontainer" {
  name                  = "vhds"
  storage_account_name = azurerm_storage_account.tfstorageaccount.name
  container_access_type = "private"
}



/*
# Creating azure virtual network
resource "azurerm_virtual_network" "tfhellonet" {
  name = "tf-vnet-1"
  location = azurerm_resource_group.tfhelloworld.location
  resource_group_name = azurerm_resource_group.tfhelloworld.name
  address_space = ["10.0.0.0/16"]
}

# Creating azure subnet
resource "azurerm_subnet" "tfsubnet1" {
  name = "tf-subnet-1"
  resource_group_name = azurerm_resource_group.tfhelloworld.name
  virtual_network_name = azurerm_virtual_network.tfhellonet.name
  address_prefixes = ["10.0.1.0/24"]
}

# Creating virtual interface card
resource "azurerm_network_interface" "tfnic1" {
  name = "tf-nic-1"
  location = azurerm_resource_group.tfhelloworld.location
  resource_group_name = azurerm_resource_group.tfhelloworld.name

  ip_configuration {
    name = "tf-ipconfig-1"
    subnet_id = azurerm_subnet.tfsubnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Creating azure virtual machine
resource "azurerm_linux_virtual_machine" "tflinuxvm1" {
  name = "tf-linux-vm-1"
  location = azurerm_resource_group.tfhelloworld.location
  resource_group_name = azurerm_resource_group.tfhelloworld.name
  size = "Standard_DS1_v2"
  admin_username = "adminuser"
  admin_password = "TF@azure1234"
  network_interface_ids = [azurerm_network_interface.tfnic1.id]
  computer_name = "tf-linux-vm-1"
  disable_password_authentication = false

  os_disk {
    name = "tf-linux-osdisk-1"
    storage_account_type = "Standard_LRS"
    caching = "ReadWrite"    
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  
}
*/
