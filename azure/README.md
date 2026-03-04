# Terraform Sandbox - Azure

This module contains a sandbox environment for creating Azure resources with [Terraform](https://developer.hashicorp.com/terraform).

## Modules

- [Foundation](./modules/foundation/main.tf): Provisions the Resource Group for resources in the environment
- [Security](./modules/foundation/main.tf): Provisions security resources, such as network security rules.
- [Network](./modules/foundation/main.tf): Provisions network resources, such as virtual networks, subnets, NAT gateways, and application gateways
- [Compute](./modules/foundation/main.tf): In Progress
- [Storage](./modules/foundation/main.tf): In Progress
- [Messaging](./modules/foundation/main.tf): In Progress

## Environments

There are 4 unique environments, each with their own separate Terraform state:

- [DEV](./environments/dev/main.tf)
- [QA](./environments/dev/main.tf)
- [UAT](./environments/dev/main.tf)
- [PROD](./environments/dev/main.tf)
