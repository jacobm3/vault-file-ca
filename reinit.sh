#!/bin/bash 

set -e
set -x

while [ "$(pgrep vault)" ]; do
  pkill vault
  sleep 0.5
done

rm -fr data vault.log vault.err

# setup vault.hcl

cat > vault.hcl <<EOF
storage "file" {
  path = "${PWD}/data"
}

listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = 1
}

license_path = "${HOME}/.vault-license"
disable_mlock = true
log_level = "debug"
EOF

vault server -config=vault.hcl >vault.log 2>vault.err &

sleep 1

export VAULT_ADDR=http://localhost:8200/

vault operator init -format=json -t 1 -n 1 | tee .init.json

vault operator unseal $(jq -r .unseal_keys_b64[0] < .init.json)

vault login $(jq -r .root_token < .init.json)

vault audit enable file file_path=audit hmac_accessor=false

echo
echo "Set in your environment:"
echo "export VAULT_ADDR=http://localhost:8200/"
echo