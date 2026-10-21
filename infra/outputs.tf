output "service_url" {
  description = "Public URL of the demo."
  value       = google_cloud_run_v2_service.app.uri
}

output "workload_identity_provider" {
  description = "For google-github-actions/auth: workload_identity_provider."
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "deployer_service_account" {
  description = "For google-github-actions/auth: service_account."
  value       = google_service_account.deployer.email
}

output "image_repository" {
  description = "Cloud Run pulls images through this path."
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.ghcr.repository_id}/${var.github_repo}"
}
