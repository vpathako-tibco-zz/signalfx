provider "signalfx" {
  auth_token = var.access_token
  api_url    = "https://api.${var.realm}.signalfx.com"
}

module "dashboards" {
  source     = "./dashboards"
  namespace  = var.namespace
}

