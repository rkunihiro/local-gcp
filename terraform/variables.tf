variable "project" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "bucket_name" {
  type = string
}

variable "bucket_location" {
  type    = string
  default = "US"
}

variable "access_token" {
  type      = string
  default   = null
  sensitive = true
}

variable "storage_custom_endpoint" {
  type    = string
  default = null
}
