#!/bin/bash

export PATH=.:$PATH

source zomadir.sh
source ../config-funcs.sh

dpcfg=$1

group="gs-ratelimits"

id=$(strip_quotes $(jq '.Gateway.Datapower[0].Id' $dpcfg))

zomafile=$(_zomadirf dp-gateway-peering-${group}-${id}.xml)

dp-gateway-peering.sh $dpcfg $group $zomafile

call-zoma.sh $dpcfg $zomafile
