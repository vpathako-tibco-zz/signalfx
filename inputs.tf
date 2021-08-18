variable "access_token" {
  description = "SignalFx Access Tokens"
  default     = "test"
}

variable "realm" {
  description = "SignalFx Realm"
  default     = "us1"
}

variable "namespace" {
  description = "Kubernetes Namespace"
  type = string
}
