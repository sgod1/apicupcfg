#!/bin/bash

export PATH=.:$PATH

source zomadir.sh
source ../config-funcs.sh

set -x

dpcfg=$1

id=$(strip_quotes $(jq '.Gateway.Datapower[0].Id' $dpcfg))

zomafile=$(_zomadirf dp-config-sequence-${id}.xml)

dp-config-sequence.sh $dpcfg $zomafile

call-zoma.sh $dpcfg $zomafile
