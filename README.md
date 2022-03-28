# Vault CA Demo with File Backend

This repo contains scripts that make it easy to create a local Vault PKI CA, so you can generate trusted certificates for TLS listeners in demo environments, demonstrate how to separate the root CA and intermedate CAs between Vault namespaces.

The scripts automate Vault initialization and authentication. This is not secure for production environments but is great for fast local demos.

# Additional Resources

Learn guide

https://learn.hashicorp.com/tutorials/vault/pki-engine

PKI secrets engine API reference

https://www.vaultproject.io/api-docs/secret/pki

General PKI resources

https://knowledge.digicert.com/solution/SO16297.html

https://www.venafi.com/blog/how-do-certificate-chains-work


