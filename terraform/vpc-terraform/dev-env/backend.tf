terraform {
  backend "gcs" {
    bucket = "terraform-state-dev-uzair"
    prefix = "shared-vpc"
  }
}
