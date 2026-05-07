default_project_id = "<host-project-id>"
default_region     = "asia-south1"
impersonate_service_account = "<sa>"
 
  vpc_name        = "shared-vpc"
  dev_network_host_project_id = "<host-project-id>"

  service_projects = [
    "dev-logging-opencontuzair",
    "dev-resources-opencontuzair"
  ]

  subnets = {
    web = {
      ip_cidr_range = "10.0.10.0/24"
      region        = "asia-south1"

      secondary_ranges = []
    }

    app = {
      ip_cidr_range = "10.0.20.0/24"
      region        = "asia-south1"

      secondary_ranges = []
    }

    gke = {
      ip_cidr_range = "10.0.28.0/22"
      region        = "asia-south1"

      secondary_ranges = [
        {
          range_name    = "pods"
          ip_cidr_range = "10.1.0.0/20"
        },
        {
          range_name    = "services"
          ip_cidr_range = "10.2.0.0/24"
        }
      ]
    }

    database = {
      ip_cidr_range = "10.0.40.0/24"
      region        = "asia-south1"

      secondary_ranges = []
    }
  }

  firewall_rules = {
    allow-proxy-ingress = {
      direction     = "INGRESS"
      priority      = 100
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["proxy"]

      allow = {
        protocol = "tcp"
        ports    = ["80", "443"]
      }
    }

    allow-internal = {
      direction     = "INGRESS"
      priority      = 500
      source_ranges = ["10.0.0.0/16"]

      allow = {
        protocol = "tcp"
      }
    }

    allow-icmp = {
      direction     = "INGRESS"
      priority      = 600
      source_ranges = ["10.0.0.0/16"]

      allow = {
        protocol = "icmp"
      }
    }

    allow-google-apis = {
      direction     = "EGRESS"
      priority      = 800
      source_ranges = ["0.0.0.0/0"]

      allow = {
        protocol = "tcp"
        ports    = ["443"]
      }
    }

    deny-ingress = {
      direction     = "INGRESS"
      priority      = 65534
      source_ranges = ["0.0.0.0/0"]

      deny = {
        protocol = "all"
      }
    }
  }
