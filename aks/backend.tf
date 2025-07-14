terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.35.0"
    }

  }
  backend "azurerm" {
    resource_group_name  = "ramesh-testing-eus"
    storage_account_name = "rameshsttf"
    container_name       = "terraform"
    key                  = "aks.testing.tfstate"
  }

}


provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

variable "subscription_id" {
  description = "The Subscription ID for the AzureRM provider."
  type        = string
  default     = "7c9a1f27-f753-4a88-bba8-dfdc29f4703d"
}
