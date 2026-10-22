data "google_project" "this" {}

locals {
  services = [
    "artifactregistry.googleapis.com",
    "billingbudgets.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com", # GitHub Actions impersonating the deployer
    "run.googleapis.com",
    "sts.googleapis.com", # exchanging GitHub's OIDC token
  ]
}

resource "google_project_service" "enabled" {
  for_each = toset(local.services)
  service  = each.value

  # Leave APIs on if this config is destroyed; turning them off can break other things.
  disable_on_destroy = false
}
