module "charts" {
  source = "../charts"
  namespace = var.namespace
}
resource "signalfx_dashboard_group" "slx_dashboard_group" {
  name        = "${var.dashboard_group_name}"
  description = "Dashboards for ${var.dashboard_group_name}"
}

resource "signalfx_dashboard" "slx_primary_dashboard" {
  name            = "${var.dashboard_name}"
  dashboard_group = signalfx_dashboard_group.slx_dashboard_group.id
  time_range      = "-1h"
  
  variable {
    property = "kubernetes_cluster"
    alias = "Cluser"
    values_suggested = ["us-west-2-cic20-prod","eu-west-1-cic20-prod","ap-southeast-2-cic20-prod"]
    value_required = true
    values  = ["us-west-2-cic20-prod"]
    replace_only = true
    apply_if_exist = false
  }
  chart {
    chart_id = module.charts.network_throughput
    width    = 5
    height   = 1
    row      = 1
    column   = 0
  }
  chart {
    chart_id = module.charts.active_pods
    width    = 5
    height   = 1
    row      = 0
    column   = 0
  }
  chart {
    chart_id = module.charts.network_errors
    width    = 5
    height   = 1
    row      = 1
    column   = 5
  }
  chart {
    chart_id = module.charts.pods_by_phase
    width    = 5
    height   = 1
    row      = 0
    column   = 5
  }
  chart {
    chart_id = module.charts.high_cpu_per_pod
    width    = 5
    height   = 1
    row      = 2
    column   = 0
  }
  chart {
    chart_id = module.charts.high_memory_per_pod
    width    = 5
    height   = 1
    row      = 2
    column   = 5
  }
  chart {
    chart_id = module.charts.memory_usuage_per_pod
    width    = 5
    height   = 1
    row      = 3
    column   = 5
  }
  chart {
    chart_id = module.charts.cpu_usuage_per_pod
    width    = 5
    height   = 1
    row      = 3
    column   = 0
  }
  chart {
    chart_id = module.charts.available_pods_deploy
    width    = 5
    height   = 1
    row      = 4
    column   = 0
  }
  chart {
    chart_id = module.charts.desired_pods_deploy
    width    = 5
    height   = 1
    row      = 4
    column   = 5
  }
}








