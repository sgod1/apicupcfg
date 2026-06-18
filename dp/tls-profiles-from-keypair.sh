#!/bin/bash

export PATH=.:$PATH

source ../config-funcs.sh

set -x

# prefix is part of keyname and keyfile
# id is part of keypath

dpcfg=$1

keyprefix=${2:-"gwd"}

id=$(strip_quotes $(jq '.Gateway.Datapower[0].Id' $dpcfg))

certdir=cert
mkdir -p $certdir

keyname=${keyprefix}-key
keyfile=${keyname}.pem
keypath=$certdir/${id}-${keyfile}

certname=${keyprefix}-cert
certfile=${certname}.pem
certpath=$certdir/${id}-${certfile}

dp_keypath=$certdir:///$keyfile
dp_certpath=$certdir:///$certfile

# create keypair
gen-ss-cert.sh $keypath $certpath

# upload key file
zoma-set-file.sh $dpcfg $keypath $keyname $dp_keypath

# upload cert file
zoma-set-file.sh $dpcfg $certpath $certname $dp_certpath

# create key
zoma-crypto-key.sh $dpcfg $keyname $dp_keypath

# create cert
zoma-crypto-cert.sh $dpcfg $certname $dp_certpath

# create identification cred
zoma-crypto-ident-cred.sh $dpcfg $keyprefix $keyname $certname

# create tls client profile
zoma-tls-client-profile.sh $dpcfg $keyprefix

# create tls server profile
zoma-tls-server-profile.sh $dpcfg $keyprefix
