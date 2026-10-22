# Cloud Run can't pull from ghcr.io directly, so this remote repository proxies it:
# us-central1-docker.pkg.dev/<project>/ghcr/ethan-ngo/lawgiq -> ghcr.io/ethan-ngo/lawgiq.
# CI keeps publishing to GHCR and GCP never needs registry credentials.
resource "google_artifact_registry_repository" "ghcr" {
  repository_id = "ghcr"
  location      = var.region
  format        = "DOCKER"
  mode          = "REMOTE_REPOSITORY"
  description   = "Pull-through proxy for ghcr.io images"

  remote_repository_config {
    common_repository {
      uri = "https://ghcr.io"
    }
  }

  # Stay under the 0.5 GB free storage: keep the 3 newest cached images, drop the rest after a week.
  cleanup_policy_dry_run = false
  cleanup_policies {
    id     = "keep-latest-3"
    action = "KEEP"
    most_recent_versions {
      keep_count = 3
    }
  }
  cleanup_policies {
    id     = "delete-older-than-7d"
    action = "DELETE"
    condition {
      tag_state  = "ANY"
      older_than = "604800s"
    }
  }

  depends_on = [google_project_service.enabled]
}
