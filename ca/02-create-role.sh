#!/bin/bash -x

set -e 

export VAULT_NAMESPACE=pki-ca-int
PKIPATH=pki-ca-int1

vault write ${PKIPATH}/roles/wildcard-theneutral-zone \
     allowed_domains="theneutral.zone" \
     allow_wildcard_certificates=true \
     allow_subdomains=true \
     allow_bare_domains=true \
     max_ttl="720h"

