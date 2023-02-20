#!/bin/bash -x

set -e 

. config.env

vault write ${PKIPATH}/roles/wildcard-theneutral-zone \
     allowed_domains="theneutral.zone" \
     allow_wildcard_certificates=true \
     allow_subdomains=true \
     allow_bare_domains=true \
     max_ttl="365d"

