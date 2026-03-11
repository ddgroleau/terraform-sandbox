# Terraform Sandbox - Azure

This module contains a sandbox environment for creating Azure resources with [Terraform](https://developer.hashicorp.com/terraform).

## Modules

- [Foundation](./modules/foundation/main.tf): Provisions the Resource Group for resources in the environment
- [Security](./modules/security/main.tf): Provisions security resources, such as network security rules.
- [Network](./modules/network/main.tf): Provisions network resources, such as virtual networks, subnets, NAT gateways, and application gateways
- [Compute](./modules/compute/main.tf): Provisions AKS cluster and integrates cluster network resources with Virtual Network
- [Kubernetes](./modules/kubernetes/main.tf): Provisions Kubernetes Deployment, Service and Ingress resources to enable a small web-server pod in the cluster for testing
- [Data](./modules/data/main.tf): Provisions an Azure MSSQL Server instance and database, and integrates SQL resources with Virtual Network
- [Messaging](./modules/messaging/main.tf): Provisions Azure Service Bus Namespace, Topic, Subscription and authorization rules.

## Environments

There are 4 unique environments, each with their own separate Terraform state:

- [DEV](./environments/dev/main.tf)

The below environments are added to demonstrate multi-environment setup, and are not fully-implemented:

- [QA](./environments/qa/main.tf)
- [UAT](./environments/uat/main.tf)
- [PROD](./environments/prod/main.tf)

## Testing the Sandbox

The terraform code provisions an Azure VNet, a NAT gateway for outbound traffic, an application gateway for inbound traffic, establishes subnets, configures TLS termination, and creates an AKS cluster with an Ingress, Service, and Deployment to expose a single HTTP route.

```bash
# Test GET request to receieve a response from the web server pod in the cluster:
curl -Lk http://<APP_GATEWAY_PUBLIC_IP> # Replace with your App gateway PIP
# You should recieve a text/plain response:
    # "Hello from Azure Kubernetes Service!"
```
