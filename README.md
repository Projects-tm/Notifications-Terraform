# Notifications Terraform module
Instantiates the Cloud Run Notifications service.

Designed to simplify work with the [Notifications library](https://github.com/Projects-tm/Notifications) 
for internal TeamDev use.

## Requirements

Cloud Run service account must have "Container Registry Service Agent" rights in the GCP project 
`our-tasks-infr` for accessing Notifications server docker image.

## Providers

| Name | Version     |
|------|-------------|
| <a name="provider_google"></a> [google](#provider\_google) | `>= 4.46.0` |

## Resources

| Name | Type |
|------|------|
| [google_cloud_run_v2_service.notifications_service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |
| [google_cloud_run_v2_service_iam_policy.notifications_access_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service_iam_policy) | resource |
| [google_cloud_run_service.my-app](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/cloud_run_service) | data source |
| [google_iam_policy.notifications_invoker_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The Notifications server instance name | `string` | `"notifications-server"` | no |
| project_id | The ID of the GCP project to create Notifications instances in | `string` | n/a | yes |
| region | The GCP region to create instances in | `string` | n/a | yes |
| telegram_token | The private token of the Telegram bot | `string` | `""` | no |
| vpc_network | The VPC network that should be used by the Notifications service | `any` | n/a | yes |
| vpc_subnetwork | The VPC subnetwork that should be used by the Notifications service | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| service\_url | The URL of the Notifications Cloud Run service |
