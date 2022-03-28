#!/bin/bash -x

set -e 

# Setup root CA in its own namespace
vault namespace create pki-ca-root

export VAULT_NAMESPACE=pki-ca-root

PKIPATH=pki-ca-root
ROOTNAME=hashi-demo-ca-root.2022.04

vault secrets enable -path=${PKIPATH} pki
vault secrets tune -max-lease-ttl=87600h ${PKIPATH}

vault write -field=certificate ${PKIPATH}/root/generate/internal \
     common_name="$ROOTNAME" \
     ttl=87600h > ${ROOTNAME}.crt

vault write ${PKIPATH}/config/urls \
     issuing_certificates="$VAULT_ADDR/v1/pki/ca" \
     crl_distribution_points="$VAULT_ADDR/v1/pki/crl"



