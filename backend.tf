
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-lz-terraform-prod-01"
    storage_account_name = "azsatfstateprd01"
    container_name       = "tfstate"
    key                  = "app-prod-01-prod.tfstate"
    use_oidc             = true

  }
}
