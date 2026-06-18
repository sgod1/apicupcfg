#!/bin/bash

export PATH=.:$PATH

source zomadir.sh
source ../config-funcs.sh

dpcfg=$1

id=$(strip_quotes $(jq '.Gateway.Datapower[0].Id' $dpcfg))

zomafile=$(_zomadirf dp-domain-${id}.xml)

dp-domain.sh $dpcfg $zomafile

call-zoma.sh $dpcfg $zomafile
