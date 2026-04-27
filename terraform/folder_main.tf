

resource "google_folder" "Developement" {
  display_name = "dev"
  parent       = "organizations/<Org-id>"
  deletion_protection = true

}

resource "google_folder" "Prod" {
  display_name = "prod"
  parent       = "organizations/<Org-id>"
  deletion_protection = true
  
}

resource "google_project" "dev-network-host" {
  name       = "dev-network-host"
  project_id = "dev-network-host-opencontuzair"
  billing_account = "<BIlling-id>"
  folder_id = resource.google_folder.Developement.folder_id
}

resource "google_project" "dev-resources" {
  name       = "dev-resources"
  project_id = "dev-resources-opencontuzair"
  billing_account = "<BIlling-id>"
  folder_id = resource.google_folder.Developement.folder_id
}

resource "google_project" "dev-logging" {
  name       = "dev-logging"
  project_id = "dev-logging-opencontuzair"
  billing_account = "<BIlling-id>"
  folder_id = resource.google_folder.Developement.folder_id
}
