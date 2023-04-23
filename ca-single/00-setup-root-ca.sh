#!/bin/bash -x

set -e 

. config.env

# Danger
vault secrets disable $PKIPATH

vault secrets enable -path=${PKIPATH} pki
vault secrets tune -max-lease-ttl=87600h ${PKIPATH}

vault write -field=certificate ${PKIPATH}/root/generate/internal \
     common_name="$ROOTNAME" \
     ttl=87600h > ${ROOTNAME}.crt

vault write ${PKIPATH}/config/urls \
     issuing_certificates="$VAULT_ADDR/v1/pki/ca" \
     crl_distribution_points="$VAULT_ADDR/v1/pki/crl"

cat <<EOF

# Import your new root CA in Ubuntu
# sudo cp ${ROOTNAME}.crt /usr/local/share/ca-certificates
# sudo update-ca-certificates

# WSL2 -> Win10
# cp ${ROOTNAME}.crt /mnt/c/Users/USER/Downloads/
#
# in admin powershell
# PS C:\Windows\system32> cd C:\users\USER\Downloads
# PS C:\users\USER\Downloads> Import-Certificate -FilePath ${ROOTNAME}.crt -CertStoreLocation Cert:\LocalMachine\Root

EOF