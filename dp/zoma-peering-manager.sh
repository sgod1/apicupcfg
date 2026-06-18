#!/bin/bash

export PATH=.:$PATH

source zomadir.sh
source ../config-funcs.sh

dpcfg=$1

id=$(strip_quotes $(jq '.Gateway.Datapower[0].Id' $dpcfg))

zomafile=$(_zomadirf dp-peering-manager-${id}.xml)

dp-peering-manager.sh $dpcfg $zomafile

call-zoma.sh $dpcfg $zomafile
