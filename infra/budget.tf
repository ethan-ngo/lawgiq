# Emails the billing admins at 50% and 100% of the budget. It alerts; it never stops spending.
resource "google_billing_budget" "guard" {
  billing_account = var.billing_account
  display_name    = "lawgiq demo guard"

  budget_filter {
    projects = ["projects/${data.google_project.this.number}"]
  }

  amount {
    specified_amount {
      currency_code = "USD"
      units         = tostring(var.budget_usd)
    }
  }

  threshold_rules {
    threshold_percent = 0.5
  }
  threshold_rules {
    threshold_percent = 1.0
  }

  depends_on = [google_project_service.enabled]
}
