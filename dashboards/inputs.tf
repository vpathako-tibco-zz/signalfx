variable "namespace" {
  description = "Kubernetes Namespace"
}
variable "dashboard_group_name" {
  description = "Name of the Dashboard Group"
  default = "mycdash"
}

variable "dashboard_name" {
  description = "Name of the Dashboard"
  default = "CDASH"
}
