###############################################################################
# stage environment — Terraform & provider configuration
###############################################################################

terraform {
  required_version = ">= 1.3"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.100.0"
    }
  }
}

provider "yandex" {
  # Authentication: provide EITHER token OR service_account_key_file via vars.
  token                    = var.yc_token
  service_account_key_file = var.yc_service_account_key_file

  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}
