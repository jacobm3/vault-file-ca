storage "file" {
  path = "/home/ubuntu/tmp/vault-file-ca/data"
}

listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = 1
}

license_path = "/home/ubuntu/.vault-license"
disable_mlock = true
log_level = "debug"
