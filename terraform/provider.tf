terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.29.0"
    }
  }
}

provider "google" {
  project     = "project-3e1deed5-8dd8-41d2-8f2"
  region      = "us-central1"
  impersonate_service_account = "terrafrom-root-sa@<ProjectID>.iam.gserviceaccount.com"
}

terraform {
  backend "gcs" {
    bucket  = "terraform-state-backends"
    prefix  = "terraform/state"
  }
}
