variable "AZURE_RG" {
  type = string
}

variable "AZURE_LOCATION" {
  type = string
}
variable "AZURE_ASP_NAME" {
  type = string
}

variable "AZURE_ASP_SKU_SIZE" {
  type = string
}

variable "AZURE_ASP_SO" {
  type = string
}

variable "AZURE_APP_NAME" {
  type = string
}

variable "DOCKER_REGISTRY_SERVER_URL" {
  type = string
  default = ""
}

variable "DOCKER_REGISTRY_SERVER_USERNAME" {
  type = string
  default = ""
}

variable "DOCKER_REGISTRY_SERVER_PASSWORD" {
  type = string
  default = ""
}

# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Azure App Service Plan
resource "azurerm_service_plan" "app_service_plan" {

  name                = var.AZURE_ASP_NAME
  location            = var.AZURE_LOCATION
  resource_group_name = var.AZURE_RG

  os_type  = var.AZURE_ASP_SO
  sku_name = var.AZURE_ASP_SKU_SIZE

}

# Azure App Service (Web App for Containers)
resource "azurerm_linux_web_app" "app_service" {
  name                = var.AZURE_APP_NAME
  location            = var.AZURE_LOCATION
  resource_group_name = var.AZURE_RG
  service_plan_id = azurerm_service_plan.app_service_plan.id

  app_settings = {
    "WEBSITES_PORT" = "8080"
    "DOCKER_REGISTRY_SERVER_URL" = var.DOCKER_REGISTRY_SERVER_URL
    "DOCKER_REGISTRY_SERVER_USERNAME" = var.DOCKER_REGISTRY_SERVER_USERNAME
    "DOCKER_REGISTRY_SERVER_PASSWORD" = var.DOCKER_REGISTRY_SERVER_PASSWORD
  }

  site_config {
    always_on              = true
    app_command_line       = ""
    remote_debugging_enabled = false
  }
}