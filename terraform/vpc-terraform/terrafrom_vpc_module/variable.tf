variable "dev_network_host_project_id" {
  description = "Project ID of Shared VPC host project"
  type        = string
}

variable "vpc_name" {
  description = "Name of Shared VPC network"
  type        = string
}

variable "service_projects" {
  description = "List of service projects attached to Shared VPC"
  type        = list(string)
}

variable "default_project_id" {
  description = "default_project_id"
  type        = string
}

variable "default_region" {
  description = "default_region"
  type        = string
}

variable "impersonate_service_account" {
  description = "impersonate_service_account"
  type        = string
}


variable "subnets" {
  description = "Map of subnet definitions"

  type = map(object({
    ip_cidr_range = string
    region        = string

    secondary_ranges = list(object({
      range_name    = string
      ip_cidr_range = string
    }))
  }))
}

variable "firewall_rules" {
  description = "Firewall rules for Shared VPC"

  type = map(object({
    direction     = string
    priority      = number
    source_ranges = optional(list(string))
    target_tags   = optional(list(string))

    allow = optional(object({
      protocol = string
      ports    = optional(list(string))
    }))

    deny = optional(object({
      protocol = string
    }))
  }))
}
