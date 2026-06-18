#!/bin/bash

export PATH=.:$PATH

source zomadir.sh
source ../config-funcs.sh

set -x

dpcfg=$1
prefix=$2

id=$(strip_quotes $(jq '.Gateway.Datapower[0].Id' $dpcfg))

zomafile=$(_zomadirf dp-tls-server-profile-${id}-${prefix}.xml)

dp-tls-server-profile.sh $dpcfg $prefix $zomafile

call-zoma.sh $dpcfg $zomafile
