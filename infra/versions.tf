terraform {
  required_version = ">= 1.9"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.8"
    }
  }

  # Remote state, so CI and every machine see the same infrastructure. The bucket is the
  # one thing created by hand (see infra/README.md): Terraform can't store state in a
  # bucket it hasn't created yet.
  backend "gcs" {
    bucket = "lawgiq-626002-tfstate"
    prefix = "lawgiq"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region

  # The Budgets API needs a quota project when called with user credentials.
  user_project_override = true
  billing_project       = var.project_id
}
