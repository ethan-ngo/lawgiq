# These were first created by hand with gcloud. Import blocks adopt them into state on the
# next apply instead of trying to create duplicates. Once imported they are no-ops, and
# they can be deleted (keep them if you want the history of how the project started).

import {
  to = google_artifact_registry_repository.ghcr
  id = "projects/${var.project_id}/locations/${var.region}/repositories/ghcr"
}

import {
  to = google_cloud_run_v2_service.app
  id = "projects/${var.project_id}/locations/${var.region}/services/lawgiq"
}

import {
  to = google_cloud_run_v2_service_iam_member.public
  id = "projects/${var.project_id}/locations/${var.region}/services/lawgiq roles/run.invoker allUsers"
}

import {
  to = google_billing_budget.guard
  id = "billingAccounts/${var.billing_account}/budgets/1250660c-4ed4-41c7-8a93-55e1cd48f4f8"
}
