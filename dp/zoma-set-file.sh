#!/bin/bash

export PATH=.:$PATH

source zomadir.sh
source ../config-funcs.sh

dpcfg=$1

keypath=$2
keyname=$3
dppath=$4

id=$(strip_quotes $(jq '.Gateway.Datapower[0].Id' $dpcfg))

zomapath=$(_zomadirf dp-set-file-${id}-${keyname}.xml)

dp-set-file.sh $dpcfg $keypath $zomapath $dppath

call-zoma.sh $dpcfg $zomapath

# delete output file
