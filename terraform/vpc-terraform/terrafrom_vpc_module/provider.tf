terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.29.0"
    }
  }
}

provider "google" {
  project     = var.default_project_id
  region      = var.default_region
  impersonate_service_account = var.impersonate_service_account
}

## Backend state file
terraform {
  backend "gcs" {}
}
