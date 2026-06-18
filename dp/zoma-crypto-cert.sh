#!/bin/bash

export PATH=.:$PATH

source zomadir.sh
source ../config-funcs.sh

dpcfg=$1
certname=$2
dpcertfile=$3

id=$(strip_quotes $(jq '.Gateway.Datapower[0].Id' $dpcfg))

zomafile=$(_zomadirf dp-crypto-cert-${id}-${certname}.xml)

dp-crypto-cert.sh $dpcfg $certname $dpcertfile $zomafile

call-zoma.sh $dpcfg $zomafile
