#!/bin/bash -x

set -e 

export VAULT_NAMESPACE=pki-ca-int
PKIPATH=pki-ca-int1

NAME=wildcard-theneutral-zone
mkdir -p $NAME

vault write -format=json ${PKIPATH}/issue/${NAME} \
  common_name="*.theneutral.zone" | tee ${NAME}/${NAME}.json

cd $NAME
jq -r .data.private_key < ${NAME}.json > ${NAME}.key
jq -r .data.certificate < ${NAME}.json > ${NAME}.crt
jq -r .data.ca_chain < ${NAME}.json > ${NAME}.ca_chain
jq -r .data.issuing_cert < ${NAME}.json > ${NAME}.issuing_cert
