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

## Testing the Sandbox

The terraform code provisions an Azure VNet, a NAT gateway for outbound traffic, an application gateway for inbound traffic, establishes subnets, configures TLS termination, and creates an AKS cluster with an Ingress, Service, and Deployment to expose a single HTTP route.

```bash
# Test GET request to receieve a response from the web server pod in the cluster:
curl -Lk http://<APP_GATEWAY_PUBLIC_IP> # Replace with your App gateway PIP
# You should recieve a text/plain response:
    # "Hello from Azure Kubernetes Service!"
```
