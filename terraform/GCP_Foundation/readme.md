
#  GCP Foundation Setup using Terraform (Org → Folder → Project)

This repository demonstrates a real-world **GCP platform foundation setup using Terraform**, including organization structure, folder hierarchy, project provisioning, and authentication patterns using service accounts and impersonation concepts.

It is designed as a **learning + production-style reference** for building scalable cloud foundations.

---

## What this project covers

This project focuses on building the **base cloud structure** in Google Cloud Platform:

- Google Cloud Organization setup (conceptual + IAM alignment)
- Folder structure creation
- Project creation under folders
- Billing account attachment
- IAM binding for service accounts
- Terraform authentication using service accounts
- Service account impersonation concepts (explored during setup)
- GCS backend preparation (for remote state storage)

---

##  Architecture Overview

The structure implemented follows a typical enterprise pattern:
```
Organization
│
├── Development Folder
│   ├── dev-network-host-project
│   ├── dev-logging-project
│   └── dev-app-project
│
├── Production Folder (planned)
│   ├── prod-network-host-project
│   └── prod-app-project
```


Each layer has a clear responsibility:

- **Organization** → Governance & IAM control
- **Folders** → Environment separation (dev/prod)
- **Projects** → Actual workload execution boundary

---

##  Authentication Approach

During this setup, multiple authentication methods were explored:

### 1. Service Account Authentication
Terraform uses a dedicated service account to provision resources:

- `terraform-root-sa`
- Assigned roles:
  - Project Creator
  - Folder Admin
  - Billing User (as needed)

### 2. Service Account Impersonation (conceptual + testing)
Instead of using raw credentials, impersonation allows:

- Running Terraform as a service account
- Without downloading long-lived keys
- Better security in CI/CD environments

Example concept:

```

User → impersonates → Terraform Service Account → creates resources

### Technologies Used
Terraform
Google Cloud Platform (GCP)
IAM & Service Accounts
Cloud Resource Manager API
Billing API
Git & GitHub for version control
