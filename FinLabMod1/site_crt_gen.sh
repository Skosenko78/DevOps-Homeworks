#!/usr/bin/env bash

export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root

vault write -format=json pki_int/issue/company-dot-com common_name="site.company.com" ttl="720h" > site.company.com.crt

cat site.company.com.crt | jq -r .data.private_key > /etc/nginx/site.company.com.crt.key
cat site.company.com.crt | jq -r .data.certificate > /etc/nginx/site.company.com.crt.pem
cat site.company.com.crt | jq -r .data.issuing_ca >> /etc/nginx/site.company.com.crt.pem

systemctl restart nginx
