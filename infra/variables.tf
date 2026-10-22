variable "project_id" {
  description = "GCP project that hosts the demo."
  type        = string
}

variable "region" {
  description = "Region for Cloud Run and Artifact Registry."
  type        = string
  default     = "us-central1"
}

variable "billing_account" {
  description = "Billing account the budget alert watches (XXXXXX-XXXXXX-XXXXXX)."
  type        = string
}

variable "github_repo" {
  description = "owner/name of the only GitHub repository allowed to deploy."
  type        = string
  default     = "ethan-ngo/lawgiq"
}

variable "initial_image" {
  description = "Image for the first deploy only. After that, CI owns the image (see lifecycle in run.tf)."
  type        = string
  default     = "us-central1-docker.pkg.dev/lawgiq-626002/ghcr/ethan-ngo/lawgiq:latest"
}

variable "budget_usd" {
  description = "Monthly budget that triggers email alerts. Alerts only; it does not stop spending."
  type        = number
  default     = 1
}
