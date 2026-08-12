terraform {
  required_version = ">= 1.3"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.100.0"
    }
  }

  backend "s3" {
    bucket    = "lunaticenslaved-test"
    key       = "terraform-state/dev.tfstate"
    region    = "ru-central1"
    endpoints = { s3 = "https://storage.yandexcloud.net" }

    # Flags required for any non-AWS S3-compatible backend. They tell the AWS
    # SDK not to perform AWS-only validation / lookups against the endpoint.
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # avoids STS GetCallerIdentity (AWS-only)
    skip_metadata_api_check     = true # do not probe the EC2 metadata endpoint
    skip_s3_checksum            = true # Yandex/MinIO do not support AWS checksums
  }
}

provider "yandex" {
  endpoint         = "api.cloud.yandex.net:443"
  storage_endpoint = "storage.yandexcloud.net"

  token     = var.yc_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

