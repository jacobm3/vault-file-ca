#!/bin/bash -x

set -e 

. config.env

vault write ${PKIPATH}/roles/${NAME} \
     allowed_domains=${NAME} \
     allow_wildcard_certificates=true \
     allow_subdomains=true \
     allow_bare_domains=true \
     max_ttl="365d"

