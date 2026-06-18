#!/bin/bash

apicupcfg=${1:-"../apicupcfg.yaml"}

mkdir -p zoma

dptemp=zoma/_dptemp.yaml

dpcfg=zoma/dpcfg1.json && echo writing $dpcfg && jq 'del(.Gateway.Datapower[1])' $apicupcfg > $dpcfg
cp $dpcfg $dptemp && echo writing $dpcfg && jq 'del(.Gateway.Datapower[1])' $dptemp > $dpcfg

dpcfg=zoma/dpcfg2.json && echo writing $dpcfg && jq 'del(.Gateway.Datapower[0])' $apicupcfg > $dpcfg
cp $dpcfg $dptemp && echo writing $dpcfg && jq 'del(.Gateway.Datapower[1])' $dptemp > $dpcfg

dpcfg=zoma/dpcfg3.json && echo writing $dpcfg && jq 'del(.Gateway.Datapower[0])' $apicupcfg > $dpcfg
cp $dpcfg $dptemp && echo writing $dpcfg && jq 'del(.Gateway.Datapower[0])' $dptemp > $dpcfg

rm $dptemp
