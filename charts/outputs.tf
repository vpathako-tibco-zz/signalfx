output "network_throughput" {
  value = "${signalfx_time_chart.network_throughput.id}"
}

output "active_pods" {
  value = "${signalfx_single_value_chart.active_pods.id}"
}

output "network_errors" {
  value = "${signalfx_list_chart.network_errors.id}"
}

output "pods_by_phase" {
  value = "${signalfx_list_chart.pods_by_phase.id}"
}

output "high_cpu_per_pod" {
  value = "${signalfx_list_chart.high_cpu_per_pod.id}"
}
output "high_memory_per_pod" {
  value = "${signalfx_list_chart.high_memory_per_pod.id}"
}

output "memory_usuage_per_pod" {
  value = "${signalfx_time_chart.memory_usuage_per_pod.id}"
}

output "cpu_usuage_per_pod" {
  value = "${signalfx_time_chart.cpu_usuage_per_pod.id}"
}
output "available_pods_deploy" {
  value = "${signalfx_single_value_chart.available_pods_deploy.id}"
}

output "desired_pods_deploy" {
  value = "${signalfx_single_value_chart.desired_pods_deploy.id}"
}
