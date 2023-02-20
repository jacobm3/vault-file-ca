#!/bin/bash -x

set -e 

. config.env

mkdir -p $NAME

vault write -format=json ${PKIPATH}/issue/${NAME} \
  common_name="*.${NAME}" | tee ${NAME}/${NAME}.json

cd $NAME
jq -r .data.private_key < ${NAME}.json > ${NAME}.key
jq -r .data.certificate < ${NAME}.json > ${NAME}.crt
jq -r .data.ca_chain < ${NAME}.json > ${NAME}.ca_chain
jq -r .data.issuing_ca < ${NAME}.json > ${NAME}.issuing_ca

cat ${NAME}.crt ${NAME}.issuing_ca >> ${NAME}.bundle.crt
