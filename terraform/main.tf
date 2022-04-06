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

resource "azurerm_service_plan" "serve_python_three_ways" {
  name                = "serve-python-three-ways"
  location            = azurerm_resource_group.demo_rg.location
  resource_group_name = azurerm_resource_group.demo_rg.name
  sku_name            = "B1"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "service_app" {
  name                = "serve-python-docker-service"
  location            = azurerm_resource_group.demo_rg.location
  resource_group_name = azurerm_resource_group.demo_rg.name
  service_plan_id     = azurerm_service_plan.serve_python_three_ways.id
  
  site_config {
    application_stack {
      docker_image = "servepythonthreeways.azurecr.io/serve-python-three-ways"
      docker_image_tag = "v1"
      python_version = "3.8"
    }

    worker_count = 1
    always_on = true
    http2_enabled = false
  }
}

resource "azurerm_storage_account" "function_storage" {
  name                     = "servepython3ways"
  resource_group_name      = azurerm_resource_group.demo_rg.name
  location                 = azurerm_resource_group.demo_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_linux_function_app" "function_app" {
  name                       = "serve-python-docker-function"
  location                   = azurerm_resource_group.demo_rg.location
  resource_group_name        = azurerm_resource_group.demo_rg.name
  service_plan_id            = azurerm_service_plan.serve_python_three_ways.id
  storage_account_name       = azurerm_storage_account.function_storage.name
  storage_account_access_key = azurerm_storage_account.function_storage.primary_access_key

  site_config {
    application_stack {
      docker {
        registry_url = "servepythonthreeways.azurecr.io"
        image_name   = "serve-python-three-ways"
        image_tag    = "v1"
      }
    }

    worker_count = 1
    always_on = false
    http2_enabled = false
  }
}