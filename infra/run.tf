# The app runs as its own identity with no roles: it only reads files baked into the image.
resource "google_service_account" "runtime" {
  account_id   = "lawgiq-run"
  display_name = "Lawgiq Cloud Run runtime"
}

resource "google_cloud_run_v2_service" "app" {
  name     = "lawgiq"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account                  = google_service_account.runtime.email
    max_instance_request_concurrency = 80

    # Scale to zero (free when idle); one instance at most caps cost and keeps the
    # in-memory demo state consistent between visitors.
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }

    containers {
      image = var.initial_image

      ports {
        container_port = 3000
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
        cpu_idle          = true # only billed while handling requests
        startup_cpu_boost = true
      }

      startup_probe {
        http_get {
          path = "/api/health"
        }
        period_seconds    = 3
        timeout_seconds   = 2
        failure_threshold = 10
      }

      liveness_probe {
        http_get {
          path = "/api/health"
        }
        period_seconds = 60
      }
    }
  }

  lifecycle {
    # GitHub Actions deploys each new image and labels the revision; Terraform owns everything else.
    ignore_changes = [
      template[0].containers[0].image,
      template[0].labels,
      labels,
      client,
      client_version,
    ]
  }

  depends_on = [google_project_service.enabled]
}

# Public website: anyone may invoke the service.
resource "google_cloud_run_v2_service_iam_member" "public" {
  name     = google_cloud_run_v2_service.app.name
  location = google_cloud_run_v2_service.app.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
