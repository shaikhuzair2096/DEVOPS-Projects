# Shared VPC Terraform - GCP Foundation

This repository contains a production-style Shared VPC implementation on Google Cloud Platform using Terraform.

It follows an enterprise-style architecture where networking is centralized in a dedicated host project and consumed by multiple service projects.

---

# Architecture Overview

```text
Organization
└── Development Folder
    ├── Host Project
    │   └── dev-network-host-opencontuzair
    │       └── shared-vpc
    │           ├── web-subnet
    │           ├── app-subnet
    │           ├── gke-subnet
    │           │   ├── pods secondary range
    │           │   └── services secondary range
    │           └── database-subnet
    │
    ├── Service Projects
    │   ├── dev-resources-opencontuzair
    │   └── dev-logging-opencontuzair
```


````md
# Shared VPC Terraform - GCP Foundation

This repository contains a production-style Shared VPC implementation on Google Cloud Platform using Terraform.

It follows an enterprise-style architecture where networking is centralized in a dedicated host project and consumed by multiple service projects.

---

# Architecture Overview

```text
Organization
└── Development Folder
    ├── Host Project
    │   └── dev-network-host-opencontuzair
    │       └── shared-vpc
    │           ├── web-subnet
    │           ├── app-subnet
    │           ├── gke-subnet
    │           │   ├── pods secondary range
    │           │   └── services secondary range
    │           └── database-subnet
    │
    ├── Service Projects
    │   ├── dev-resources-opencontuzair
    │   └── dev-logging-opencontuzair
````

---

# What This Project Creates

## Networking

* Custom mode VPC
* Shared VPC Host Project
* Service Project attachments
* Regional subnets
* Secondary IP ranges for GKE

## Security

* Firewall rules following zero-trust style design

## Project Architecture

* Centralized networking in host project
* Workloads isolated in service projects

---

# Repository Structure

```text
terraform-shared-vpc/
├── terraform_vpc_module/
│   ├── vpc_main.tf
│   ├── variables.tf
│   └── README.md
│
└── dev-env/
    ├── backend.tf
    ├── provider.tf
    ├── main.tf
    ├── variables.tf
    ├── terraform.tfvars
    ├── locals.tf
    └── README.md
```

---

# Shared VPC Design

## Host Project

Centralized project responsible for managing:

* VPC network
* Subnets
* Firewall rules

Project:

```text
dev-network-host-opencontuzair
```

---

## Service Projects

Attached service projects consuming host network:

* dev-resources-opencontuzair
* dev-logging-opencontuzair

These projects do not own networking resources directly.

---

# Subnet Planning

IP ranges were planned before provisioning.

## Subnets

| Subnet   | CIDR         | Region      | Purpose               |
| -------- | ------------ | ----------- | --------------------- |
| web      | 10.0.10.0/24 | asia-south1 | frontend / proxy tier |
| app      | 10.0.20.0/24 | asia-south1 | backend services      |
| gke      | 10.0.28.0/22 | asia-south1 | kubernetes workloads  |
| database | 10.0.40.0/24 | asia-south1 | database tier         |

---

## GKE Secondary IP Ranges

| Range    | CIDR        | Purpose             |
| -------- | ----------- | ------------------- |
| pods     | 10.1.0.0/20 | pod IP allocation   |
| services | 10.2.0.0/24 | kubernetes services |

---

# Firewall Rules

Implemented firewall rules:

| Rule                | Direction | Purpose                        |
| ------------------- | --------- | ------------------------------ |
| allow-proxy-ingress | INGRESS   | allow 80/443 traffic           |
| allow-internal      | INGRESS   | allow internal communication   |
| allow-icmp          | INGRESS   | allow ICMP for troubleshooting |
| allow-google-apis   | EGRESS    | allow HTTPS to Google APIs     |
| deny-ingress        | INGRESS   | deny all remaining ingress     |

Firewall naming automatically converts underscores to hyphens.

---

# Terraform Features Used

This project intentionally uses production-grade Terraform patterns.

## Features

* Modules
* for_each
* dynamic blocks
* locals
* tfvars
* remote backend
* service account impersonation

---

## Dynamic Blocks

Used for:

* Secondary subnet ranges
* Firewall allow/deny blocks

Example use case:

```hcl
dynamic "secondary_ip_range" {
  for_each = each.value.secondary_ranges

  content {
    range_name    = secondary_ip_range.value.range_name
    ip_cidr_range = secondary_ip_range.value.ip_cidr_range
  }
}
```

---

# Deployment

## Initialize

```bash
terraform init
```

---

## Plan

```bash
terraform plan
```

---

## Apply

```bash
terraform apply
```

---

# Validation Performed

After deployment verified:

* Shared VPC host enabled
* Service projects attached
* VPC created successfully
* Subnets created successfully
* Secondary ranges attached
* Firewall rules created
* Shared VPC visible in service projects

---

# Required IAM Roles

Deployment identity requires:

* roles/compute.xpnAdmin
* roles/compute.networkAdmin
* roles/compute.networkUser

---

# Important Learnings

While building this project:

* Learned Shared VPC architecture
* Learned subnet CIDR planning
* Learned subnet boundary calculations
* Learned dynamic blocks in Terraform
* Learned module design patterns
* Learned IAM requirements for Shared VPC

---

# Future Improvements

Planned next additions:

* Cloud NAT
* Cloud Router
* Private Google Access
* VPC Flow Logs
* Private Service Connect
* Cloud DNS
* Hierarchical Firewall Policies
* GKE deployment on Shared VPC

---

# Notes

Key GCP networking concepts learned:

* VPC is global
* Subnets are regional
* Shared VPC requires:

  * host project enablement
  * service project attachment
  * subnet/network permissions

---

# Author

Built as hands-on infrastructure practice for learning production-grade GCP networking and Terraform module design.

```
```
