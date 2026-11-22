terraform {
  # 環境ごとの保存先は init 時に -backend-config で渡す (env/<環境>/backend.hcl)
  backend "local" {}

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region

  # エミュレータ接続用。実環境では null (既定) のままにする
  access_token            = var.access_token
  storage_custom_endpoint = var.storage_custom_endpoint
}

resource "google_storage_bucket" "sample" {
  name     = var.bucket_name
  location = var.bucket_location
}
