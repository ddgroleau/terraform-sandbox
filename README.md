# Terraform Sandbox

This repository contains a sandbox environment for managing Azure resources using [Terraform](https://developer.hashicorp.com/terraform).

## Azure Terraform Directory

- [Azure Root](./azure/README.md)
  - [Modules](./azure/modules/)
  - [Environments](./azure/environments/)

## Generating Self-Signed HTTPS Certs for Development

This project uses self-signed HTTPS certificates for local development. You can use the bash commands below to create your own self-signed certificate:

```bash
openssl req -x509 -nodes -newkey rsa:2048 -keyout tls.key -out tls.crt -days 365 -subj "/CN=*.local"
openssl pkcs12 -export -out cert.pfx -inkey tls.key -in tls.crt -password pass:ChangeMe123
```
