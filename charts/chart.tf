resource "signalfx_time_chart" "network_throughput" {
  name        = "Network Throughput (bytes/sec)"
  description = "Ratio of successes to total operations."

  program_text = <<-EOF
        A = data('pod_network_receive_bytes_total', filter=filter('kubernetes_namespace',"${var.namespace}"), rollup='rate', extrapolation='zero').sum().publish(label='A')
        B = data('pod_network_transmit_bytes_total', filter=filter('kubernetes_namespace', "${var.namespace}"), rollup='rate', extrapolation='zero').sum().publish(label='B')
        EOF

  plot_type         = "LineChart"
  show_data_markers = false
}

resource "signalfx_time_chart" "memory_usuage_per_pod" {
  name        = "Memory Usage per Pod"
  description = "Memory Usuage"
  
  program_text = <<-EOF
	A = data('container_memory_usage_bytes', filter=filter('kubernetes_namespace',"${var.namespace}") and filter('topology_kubernetes_io_region', 'us-west-2'), rollup='rate', extrapolation='zero').sum(by=['kubernetes_pod_name']).publish(label='A')
	EOF
  
  plot_type         = "LineChart"
  show_data_markers = false
}

resource "signalfx_time_chart" "cpu_usuage_per_pod" {
  name        = "CPU Usage per Pod"
  description = "CPU Usuage"

  program_text = <<-EOF
	A = data('container_cpu_utilization', filter=filter('kubernetes_namespace',"${var.namespace}") and filter('topology_kubernetes_io_region', 'us-west-2')).sum(by=['kubernetes_pod_name', 'kubernetes_node', 'kubernetes_cluster']).publish(label='A', enable=False)
	B = data('cpu.num_processors', filter=filter('kubernetes_node', '*')).sum(by=['kubernetes_node']).publish(label='B', enable=False)
	C = (A/B).publish(label='C')
        EOF

  plot_type         = "LineChart"
  show_data_markers = false
}

resource "signalfx_single_value_chart" "active_pods" {
  name = "Active Pods"

  program_text = <<-EOF
	A = data('container_cpu_utilization', filter=filter('kubernetes_namespace',"${var.namespace}"), rollup='rate').sum(by=['kubernetes_pod_name']).count(by=['kubernetes_cluster']).publish(label='A')
        EOF

  description = "Active Pods"
  color_by = "Dimension"
  max_delay           = 2
  refresh_interval    = 1
  max_precision       = 2
  is_timestamp_hidden = true
}

resource "signalfx_single_value_chart" "available_pods_deploy" {
  name = "Available Pods by Deployments"

  program_text = <<-EOF
	A = data('kubernetes.deployment.available', filter=filter('kubernetes_namespace',"${var.namespace}") and filter('deployment', '*'), rollup='latest').sum(by=['kubernetes_cluster']).publish(label='A')
        EOF

  description = "Available Pods by Deployments"
  color_by = "Dimension"
  max_delay           = 2
  refresh_interval    = 1
  max_precision       = 2
  is_timestamp_hidden = true
}

resource "signalfx_single_value_chart" "desired_pods_deploy" {
  name = "Desired Pods by Deployments"

  program_text = <<-EOF
	A = data('kubernetes.deployment.desired', filter=filter('kubernetes_namespace',"${var.namespace}") and filter('deployment', '*'), rollup='latest').sum(by=['kubernetes_cluster']).publish(label='A')
        EOF

  description = "Desired Pods by Deployments"
  color_by = "Dimension"
  max_delay           = 2
  refresh_interval    = 1
  max_precision       = 2
  is_timestamp_hidden = true
}

resource "signalfx_list_chart" "high_cpu_per_pod" {
  name = "Highest CPU Use per Pod (%)"

  program_text = <<-EOF
	A = data('container_cpu_utilization', filter=filter('kubernetes_namespace',"${var.namespace}"), rollup='rate').publish(label='A', enable=False)
	B = (A).sum(by=['kubernetes_pod_name']).mean(over='1m').top(count=10).publish(label='B')
	EOF

  description = "Highest CPU Use per Pod (%)"
  color_by         = "Metric"
  max_delay        = 2
  disable_sampling = true
  refresh_interval = 1
  hide_missing_values = true
  max_precision = 2
  sort_by       = "-value"
}

resource "signalfx_list_chart" "high_memory_per_pod" {
  name = "Highest Memory Use per Pod (bytes)"

  program_text = <<-EOF
	A = data('container_memory_usage_bytes', filter=filter('kubernetes_namespace',"${var.namespace}"), extrapolation='last_value').sum(by=['kubernetes_pod_name']).mean(over='1m').top(count=10).publish(label='A')
	EOF

  description = "Highest Memory Use per Pod (bytes)"
  color_by         = "Metric"
  max_delay        = 2
  disable_sampling = true
  refresh_interval = 1
  hide_missing_values = true
  max_precision = 2
  sort_by       = "-value"
}

resource "signalfx_list_chart" "network_errors" {
  name = "Network Errors / sec"

  program_text = <<-EOF
	A = data('pod_network_receive_errors_total', filter=filter('kubernetes_namespace',"${var.namespace}"), rollup='rate').sum().publish(label='A')
	B = data('pod_network_transmit_errors_total', filter=filter('kubernetes_namespace',"${var.namespace}"), rollup='rate').sum().publish(label='B')
	EOF

  description = "Network Errors / sec"
  color_by         = "Metric"
  max_delay        = 2
  disable_sampling = true
  refresh_interval = 1
  hide_missing_values = true
  max_precision = 2
  sort_by       = "-value"
}

resource "signalfx_list_chart" "pods_by_phase" {
  name = "Pods by Phase"

  program_text = <<-EOF
	A = data('kubernetes.pod_phase', filter=filter('kubernetes_namespace',"${var.namespace}"), rollup='latest').below(1, inclusive=True).count().publish(label='Pending')
	B = data('kubernetes.pod_phase', filter=filter('kubernetes_namespace',"${var.namespace}"), rollup='latest').between(1.1, 2, low_inclusive=True, high_inclusive=True).count(by=['kubernetes_cluster']).publish(label='Running')
	C = data('kubernetes.pod_phase', filter=filter('kubernetes_namespace',"${var.namespace}"), rollup='latest').between(2.1, 3, low_inclusive=True, high_inclusive=True).count().publish(label='Succeeded')
	D = data('kubernetes.pod_phase', filter=filter('kubernetes_namespace',"${var.namespace}"), rollup='latest').between(3.1, 4, low_inclusive=True, high_inclusive=True).count().publish(label='Failed')
	E = data('kubernetes.pod_phase', filter=filter('kubernetes_namespace',"${var.namespace}"), rollup='latest').above(4).count().publish(label='Unknown')
	EOF

  description = "Very cool List Chart"
  color_by         = "Metric"
  max_delay        = 2
  disable_sampling = true
  refresh_interval = 1
  hide_missing_values = true
  max_precision = 2
  sort_by       = "-value"
}

