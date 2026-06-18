#!/bin/bash

export PATH=.:$PATH

source zomadir.sh
source ../config-funcs.sh

set -x

dpcfg=$1
prefix=$2
keyname=$3
certname=$4

id=$(strip_quotes $(jq '.Gateway.Datapower[0].Id' $dpcfg))

zomafile=$(_zomadirf dp-crypto-ident-${id}-${prefix}.xml)

dp-crypto-ident-cred.sh $dpcfg $prefix $keyname $certname $zomafile

call-zoma.sh $dpcfg $zomafile
