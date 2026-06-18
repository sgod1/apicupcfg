#!/bin/bash

export PATH=.:$PATH

source zomadir.sh
source ../config-funcs.sh

dpcfg=$1
prefix=${2:-"gwd"}

id=$(strip_quotes $(jq '.Gateway.Datapower[0].Id' $dpcfg))

zomafile=$(_zomadirf dp-apic-gateway-service-${id}.xml)

dp-apic-gateway-service.sh $dpcfg $prefix $zomafile

call-zoma.sh $dpcfg $zomafile
