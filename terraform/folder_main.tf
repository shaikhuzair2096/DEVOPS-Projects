

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


# ============= ORG LEVEL =============

# Audit Logging
resource "google_organization_audit_config" "primary" {
  org_id = var.<Org-id>

  service = "allServices"
  audit_log_configs {
    log_type = "ADMIN_WRITE"
  }
  audit_log_configs {
    log_type = "DATA_WRITE"
  }
  audit_log_configs {
    log_type = "DATA_READ"
  }
}

# Org Policies (examples)
resource "google_org_policy_policy" "disable_public_ip" {
  name   = "organizations/<Org-id>/policies/compute.skipDefaultNetworkCreation"
  parent = "organizations/<Org-id>"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

resource "google_org_policy_policy" "require_encryption" {
  name   = "organizations/<Org-id>/policies/compute.requireEncryptionAtRest"
  parent = "organizations/<Org-id>"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

# ============= FOLDER LEVEL =============

# Folder IAM - restrict to folder level

resource "google_folder_iam_binding" "folder_admin" {
  folder = var.folder_id
  role   = "roles/resourcemanager.folderAdmin"

  members = [
    "group:gcp-admins@company.com"
  ]
}

# Billing budget
resource "google_billing_budget" "folder_budget" {
  billing_account = "XXXXXX"  # Replace with billing account ID
  display_name    = "${var.environment}-budget"
  budget_filter {
    projects = ["projects/${var.project_id}"]
  }

  amount {
    specified_amount {
      currency_code = "USD"
      units         = "1000"
    }
  }

  threshold_rules {
    threshold_percent = 50
  }
  threshold_rules {
    threshold_percent = 90
  }
  threshold_rules {
    threshold_percent = 100
  }
}
