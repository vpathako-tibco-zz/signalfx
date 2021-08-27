**Requires Terraform (minimum) v0.14**

## Initialise Terraform

```
$ terraform init --upgrade
```

## Create a workspace for the prospect (Optional)

```
$ terraform workspace new my_prospect
```
Where `my_prospect` is the company name of the prospect

## Review the execution plan

```
$ terraform plan -var="access_token=abc123" -var="namespace=<tenant_namespace>"
```

Where `access_token` is the SignalFx Access Token and `realm` is either `eu0`, `us0`, `us1` or `us2`

## Apply the changes

```
$ terraform apply -var="access_token=abc123" -var="namespace=<tenant_namespace>"
```

## Destroy everything!

If you created a workspace you will first need to ensure you are in the correct workspace e.g.

```
$ terraform workspace select my_prospect
```
Where `my_prospect` is the company name of the prospect

```
$ terraform destroy -var="access_token=abc123" -var="namespace=<tenant_namespace>"
```

# Deploying a module

```
terraform apply -var="access_token=abc123" -var="namespace=mynamespace"
terraform apply -var="access_token=abc123" -var="namespace=mynamespace" -target=module.dashboards
terraform apply -var="access_token=abc123" -var="namespace=mynamespace" -target=module.charts
```

