
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




# Creating azure virtual network
resource "azurerm_virtual_network" "tfhellonet" {
  name = "tf-vnet-1"
  location = azurerm_resource_group.tflearning.location
  resource_group_name = azurerm_resource_group.tflearning.name
  address_space = ["10.0.0.0/16"]
}

# Creating azure subnet
resource "azurerm_subnet" "tfsubnet1" {
  name = "tf-subnet-1"
  resource_group_name = azurerm_resource_group.tflearning.name
  virtual_network_name = azurerm_virtual_network.tfhellonet.name
  address_prefixes = ["10.0.1.0/24"]
}

# Creating virtual interface card
resource "azurerm_network_interface" "tfnic1" {
  name = "tf-nic-1"
  location = azurerm_resource_group.tflearning.location
  resource_group_name = azurerm_resource_group.tflearning.name

  ip_configuration {
    name = "tf-ipconfig-1"
    subnet_id = azurerm_subnet.tfsubnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.tf-publicip.id
  }
  depends_on = [ 
    azurerm_virtual_network.tfhellonet, 
    azurerm_public_ip.tf-publicip 
  ]
}

# Creating azure public ip address
resource "azurerm_public_ip" "tf-publicip" {
  name                = "tf-publicip-1"
  resource_group_name = azurerm_resource_group.tflearning.name
  location            = azurerm_resource_group.tflearning.location
  allocation_method   = "Static"
}

# Creating azure managed disk
resource "azurerm_managed_disk" "tf-manageddisk" {
  name                 = "tf-managed-disk-1"
  location             = azurerm_resource_group.tflearning.location
  resource_group_name  = azurerm_resource_group.tflearning.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "50"
 
}

# Creating azure availability set
resource "azurerm_availability_set" "tf-avset" {
  name                = "tf-avset"
  location            = azurerm_resource_group.tflearning.location
  resource_group_name = azurerm_resource_group.tflearning.name
  platform_fault_domain_count = 3
  platform_update_domain_count = 3
}

# Creating azure virtual machine
resource "azurerm_linux_virtual_machine" "tflinuxvm1" {
  name = "tf-linux-vm-1"
  location = azurerm_resource_group.tflearning.location
  resource_group_name = azurerm_resource_group.tflearning.name
  size = "Standard_DS1_v2"
  admin_username = "adminuser"
  admin_password = "TF@azure1234"
  availability_set_id = azurerm_availability_set.tf-avset.id
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
  
  depends_on = [ azurerm_network_interface.tfnic1,
    azurerm_availability_set.tf-avset, 
    azurerm_managed_disk.tf-manageddisk ]
}

# Creating azure virtual machine data disk attachment
resource "azurerm_virtual_machine_data_disk_attachment" "tf-diskattach" {
  managed_disk_id    = azurerm_managed_disk.tf-manageddisk.id
  virtual_machine_id = azurerm_linux_virtual_machine.tflinuxvm1.id
  lun                = "1"
  caching            = "ReadWrite"
  depends_on = [ azurerm_linux_virtual_machine.tflinuxvm1, azurerm_managed_disk.tf-manageddisk ]
}

