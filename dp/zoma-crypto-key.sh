#!/bin/bash

export PATH=.:$PATH

source zomadir.sh
source ../config-funcs.sh

set -x

dpcfg=$1
keyname=$2
dpkeyfile=$3

id=$(strip_quotes $(jq '.Gateway.Datapower[0].Id' $dpcfg))

zomafile=$(_zomadirf dp-crypto-key-${id}-${keyname}.xml)

dp-crypto-key.sh $dpcfg $keyname $dpkeyfile $zomafile

call-zoma.sh $dpcfg $zomafile
