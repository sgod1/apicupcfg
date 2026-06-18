#!/bin/bash -x

export PATH=.:$PATH

keyfile=$1
certfile=$2

# input with jq
cn=apic1dp.roky.szesto.io
subj="/C=US/L=Los Angeles/O=datapower/CN=$cn"

openssl genpkey -algorithm RSA -out $keyfile -pkeyopt rsa_keygen_bits:2048
openssl req -new -x509 -days 365 -key $keyfile -out $certfile -subj "$subj"

