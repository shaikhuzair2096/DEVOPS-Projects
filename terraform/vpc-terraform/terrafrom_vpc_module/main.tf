
resource "google_compute_network" "shared_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  project                 = var.dev_network_host_project_id
  routing_mode            = "GLOBAL"  # Required for multi-region transitive routing
}

# A host project provides network resources to associated service projects.
resource "google_compute_shared_vpc_host_project" "host" {
  project = var.dev_network_host_project_id
}

# A service project gains access to network resources provided by its
# associated host project.
resource "google_compute_shared_vpc_service_project" "services" {
  for_each = toset(var.service_projects)

  host_project    = var.dev_network_host_project_id
  service_project = each.value
}

resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  for_each      = var.subnets
  name          = "${each.key}-subnet"
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.region
  network       = google_compute_network.shared_vpc.id
  project       = var.dev_network_host_project_id
  
  dynamic "secondary_ip_range" {
  for_each = each.value.secondary_ranges

  content {
    range_name    = secondary_ip_range.value.range_name
    ip_cidr_range = secondary_ip_range.value.ip_cidr_range
  }
}
}




resource "google_compute_firewall" "rules" {

  for_each = var.firewall_rules

  name    = each.key
  network = google_compute_network.shared_vpc.name
  project = var.dev_network_host_project_id

  direction     = each.value.direction
  priority      = each.value.priority
  source_ranges = lookup(each.value, "source_ranges", null)
  target_tags   = lookup(each.value, "target_tags", null)
  dynamic "allow" {
    for_each = lookup(each.value, "allow", null) != null ? [each.value.allow] : []
## the lookup here is used to check if key exist the syntax is lookup(each.value,key,null) the it will seach for key called allow
## if the allow exist then go for value of allow which is the content so it will show like for_each=contents that is protocol and ports
## that is the reason we used dynamic block which supports the nested blocks
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {
    for_each = lookup(each.value, "deny", null) != null ? [each.value.deny] : []

    content {
      protocol = deny.value.protocol
    }
  }
}
/*  ============================================================================
# Firewall Rules - Zero Trust Model
# ============================================================================

# Allow ingress from proxy/load balancer
resource "google_compute_firewall" "allow_proxy_ingress" {
  name    = local.firewall_rules.allow_proxy_ingress.name
  network = google_compute_network.shared_vpc.name
  project = local.project_id

  direction   = "INGRESS"
  priority    = local.firewall_rules.allow_proxy_ingress.priority
  source_ranges = local.firewall_rules.allow_proxy_ingress.source_ranges
  target_tags = local.firewall_rules.allow_proxy_ingress.target_tags

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  description = "Allow HTTP/HTTPS ingress for proxy tier"
}

# Allow all internal traffic (VPC native)
resource "google_compute_firewall" "allow_internal" {
  name    = local.firewall_rules.allow_internal.name
  network = google_compute_network.shared_vpc.name
  project = local.project_id

  direction   = "INGRESS"
  priority    = local.firewall_rules.allow_internal.priority
  source_ranges = local.firewall_rules.allow_internal.source_ranges

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  description = "Allow all internal traffic within Shared VPC"
}

# Deny all other ingress
resource "google_compute_firewall" "deny_ingress" {
  name    = local.firewall_rules.deny_ingress.name
  network = google_compute_network.shared_vpc.name
  project = local.project_id

  direction     = "INGRESS"
  priority      = local.firewall_rules.deny_ingress.priority
  source_ranges = local.firewall_rules.deny_ingress.source_ranges

  deny {
    protocol = "all"
  }

  description = "Deny all other ingress traffic (default deny)"
}

# Allow egress to Google APIs
resource "google_compute_firewall" "allow_google_apis" {
  name    = local.firewall_rules.allow_google_apis.name
  network = google_compute_network.shared_vpc.name
  project = local.project_id

  direction          = "EGRESS"
  priority           = local.firewall_rules.allow_google_apis.priority
  destination_ranges = local.firewall_rules.allow_google_apis.destination_ranges

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  description = "Allow egress to Google APIs (Private Google Access)"
}

# Allow egress to internal networks
resource "google_compute_firewall" "allow_egress_internal" {
  name    = local.firewall_rules.allow_egress_internal.name
  network = google_compute_network.shared_vpc.name
  project = local.project_id

  direction          = "EGRESS"
  priority           = local.firewall_rules.allow_egress_internal.priority
  destination_ranges = local.firewall_rules.allow_egress_internal.destination_ranges

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  description = "Allow egress to internal networks"
}

# Deny all other egress
resource "google_compute_firewall" "deny_egress" {
  name    = local.firewall_rules.deny_egress.name
  network = google_compute_network.shared_vpc.name
  project = local.project_id

  direction          = "EGRESS"
  priority           = local.firewall_rules.deny_egress.priority
  destination_ranges = local.firewall_rules.deny_egress.destination_ranges

  deny {
    protocol = "all"
  }

  description = "Deny all other egress traffic"
}
 */
