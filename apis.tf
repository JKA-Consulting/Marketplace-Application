locals {
  all_project_services = concat(var.gcp_service_list)
}

resource "google_project_service" "enabled_apis" {
  service                    = each.key
  project                    = var.project-id
  for_each                   = toset(local.all_project_services)
  disable_dependent_services = true
  disable_on_destroy         = true
}