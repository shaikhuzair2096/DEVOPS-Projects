module "shared_vpc"{
    source = "../terrafrom_vpc_module"
    vpc_name = var.vpc_name
    dev_network_host_project_id = var.dev_network_host_project_id
    service_projects = var.service_projects
    subnets = var.subnets
    firewall_rules = var.firewall_rules
    default_project_id = var.default_project_id
    default_region     = var.default_region
    impersonate_service_account = var.impersonate_service_account

}
