#!/bin/bash -x

set -e 


PKIPATH=pki-ca-root
ROOTNAME=acer5-demo-ca-root.2022.04

vault secrets enable -path=${PKIPATH} pki
vault secrets tune -max-lease-ttl=87600h ${PKIPATH}

vault write -field=certificate ${PKIPATH}/root/generate/internal \
     common_name="$ROOTNAME" \
     ttl=87600h > ${ROOTNAME}.crt

vault write ${PKIPATH}/config/urls \
     issuing_certificates="$VAULT_ADDR/v1/pki/ca" \
     crl_distribution_points="$VAULT_ADDR/v1/pki/crl"

# works in ubuntu 20
# sudo cp ${ROOTNAME}.crt /usr/local/share/ca-certificates
# sudo update-ca-certificates

# WSL2 -> Win10
# cp ${ROOTNAME}.crt /mnt/c/Users/jacob/Downloads/
#
# in admin powershell
# PS C:\Windows\system32> cd C:\users\jacob\Downloads\
# PS C:\users\jacob\Downloads> Import-Certificate -FilePath .\hashi-demo-ca-root.2022.04.crt -CertStoreLocation Cert:\LocalMachine\Root
