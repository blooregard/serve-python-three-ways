terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "demo_rg" {
  name     = "python-served-three-ways-rg"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "demo_aks" {
  name                = "python-aks"
  location            = azurerm_resource_group.demo_rg.location
  resource_group_name = azurerm_resource_group.demo_rg.name
  dns_prefix          = "python3ways"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

    count = var.use_aks ? 1 : 0

  tags = {
    Environment = "Demo"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "servepythonthreeways"
  resource_group_name = azurerm_resource_group.demo_rg.name
  location            = azurerm_resource_group.demo_rg.location
  sku                 = "Basic"
  admin_enabled       = false
}