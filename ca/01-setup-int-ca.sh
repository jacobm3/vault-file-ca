#!/bin/bash -x

set -e 

# Setup the intermediates
INTNS=pki-ca-int
vault namespace create $INTNS

export VAULT_NAMESPACE=$INTNS
PKIPATH=pki-ca-int1
INTNAME=hashi-demo-ca-int1.2022.04

vault secrets enable -path=${PKIPATH} pki
vault secrets tune -max-lease-ttl=43800h ${PKIPATH}

vault write -format=json ${PKIPATH}/intermediate/generate/internal \
     common_name="$INTNAME" \
     | jq -r '.data.csr' > ${INTNAME}.csr


# Sign the intermediate. In a production environment, this would likely be
# done with a separate Vault auth/token, possibly by a different team
export VAULT_NAMESPACE=pki-ca-root
PKIPATH=pki-ca-root
vault write -format=json ${PKIPATH}/root/sign-intermediate csr=@${INTNAME}.csr \
     format=pem_bundle ttl="43800h" \
     | jq -r '.data.certificate' > ${INTNAME}.crt


# Import signed intermedate cert
export VAULT_NAMESPACE=$INTNS
PKIPATH=pki-ca-int1
INTNAME=hashi-demo-ca-int1.2022.04

vault write ${PKIPATH}/intermediate/set-signed certificate=@${INTNAME}.crt

